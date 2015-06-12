class LotteryWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3

  def perform(lottery_event_id)
    event = LotteryEvent.find_by(id: lottery_event_id)
    return false if event.nil?
    logger.info "event_id: #{lottery_event_id}, showtime_id: #{event.showtime.id}"
    case event.lottery_rule
    when 'enrollment'
      logger.info 'enrollment'
      logger.info event.showtime.enrollees.map { |u| "#{u.nickname} @#{u.username}" }.join(' | ')
    when 'ballot'
      logger.info 'ballot'
      logger.info event.showtime.ballot.users_with_votes_for_own_uni(university).map { |u| "#{u.nickname} @#{u.username}" }.join(' | ')
    end
  end
end
