class Lottery < ActiveRecord::Base
  belongs_to :user
  belongs_to :lottery_event
  after_initialize :default_values

  validates :user, presence: true, uniqueness: { scope: :lottery_event }
  validates :lottery_event, presence: true
  validate :lottery_event_should_not_be_drawn

  private

  def default_values
    hit = false if hit.nil?
  end

  # To set a lottery_event to be drawn, use #update_attribute to skip validations
  def lottery_event_should_not_be_drawn
    errors.add(:base, '抽奖已结束') if lottery_event.try(:drawn?)
  end
end
