require "#{Rails.root}/lib/exceptions/campify_error"

class LotteryEvent < ActiveRecord::Base
  include Redis::Objects
  include Exceptions

  belongs_to :showtime
  has_many :lotteries, dependent: :destroy
  has_many :winners, -> { where('lotteries.hit' => true) },
    through: :lotteries, source: :user

  value :job_id
  value :last_failure_code

  after_initialize :default_values
  after_commit :schedule_lottery_event, on: [ :create, :update ]
  after_commit :cancel_lottery_event, on: [ :destroy ]

  validates :showtime, presence: true, uniqueness: true
  validates :draws_at, presence: true
  validates :lottery_rule, presence: true
  validates :prizes_num, presence: true, inclusion: { in: 1..1000 } 
  validates :prize_type, presence: true
  validate :draws_at_must_be_in_future
  validate :check_lottery_rule
  validate :check_drawn_status, on: [ :create, :update ]

  def draw
    return false if drawn?
    users = determine_candidates
    return false if users.nil?
    ones = users.select(:id).reorder('RANDOM()').limit(prizes_num)

    ret = lotteries.create(ones.map { |u| { user_id: u.id } }) { |l| l.hit = true }
    if ret
      update_attribute(:drawn, true)
      last_failure_code.delete
      true
    else
      last_failure_code.value = 'lottery_creating_failure'
      false
    end
  end

  def on_enrollment?
    lottery_rule == 'enrollment'
  end

  def on_ballot?
    lottery_rule == 'ballot'
  end

  private

  def draws_at_must_be_in_future
    errors.add(:draws_at, '必须大于当前时间') if draws_at && draws_at < Time.now
  end

  def check_lottery_rule
    case lottery_rule
    when 'enrollment'
      unless showtime.enrollable? || showtime.enrollments.present?
        errors.add(:lottery_rule, '无效，报名尚未开启')
      end
    when 'ballot'
      errors.add(:lottery_rule, '无效，投票尚未开启') unless showtime.ballot
    else
      errors.add(:lottery_rule, '是无效的')
    end
  end

  def check_drawn_status
    errors.add(:base, '抽奖已结束，无法修改抽奖设置') if drawn?
  end

  def default_values
    prize_type ||= 'normal'
    drawn = false if drawn.nil?
  end

  def schedule_lottery_event
    job_id.value = LotteryWorker.perform_at(draws_at, id)
  end

  def cancel_lottery_event
    job_id.delete
    last_failure_code.delete
  end

  def determine_candidates
    case lottery_rule
    when 'enrollment'
      showtime.enrollees
    when 'ballot'
      ballot = showtime.ballot
      return nil unless ballot.present?
      unis = ballot.most_voted_universities

      case unis.count
      when 1
        ballot.users_with_votes_for_own_uni(unis.first)
      when 0
        last_failure_code.value = 'no_universities_available'
        nil
      else
        last_failure_code.value = 'multi_most_voted_universities'
        nil
      end
    else
      raise CampifyError::InvalidLotteryRule
    end
  end
end
