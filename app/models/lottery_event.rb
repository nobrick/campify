class LotteryEvent < ActiveRecord::Base
  belongs_to :showtime
  after_initialize :default_values

  validates :showtime, presence: true, uniqueness: true
  validates :draws_at, presence: true
  validates :lottery_rule, presence: true
  validates :prizes_num, presence: true, inclusion: { in: 1..1000 } 
  validates :prize_type, presence: true
  validate :draws_at_must_be_in_future
  validate :check_lottery_rule

  private

  def draws_at_must_be_in_future
    errors.add(:draws_at, '必须大于当前时间') if draws_at && draws_at < Time.now
  end

  def check_lottery_rule
    case lottery_rule
    when 'enrollment'
      errors.add(:lottery_rule, '无效，报名尚未开启') unless showtime.enrollable?
    when 'ballot'
      errors.add(:lottery_rule, '无效，投票尚未开启') unless showtime.ballot
    else
      errors.add(:lottery_rule, '是无效的')
    end
  end

  def default_values
    prize_type ||= 'normal'
  end
end
