class LotteryWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(lottery_event_id)
    event = LotteryEvent.find_by(id: lottery_event_id)
    return if event.nil? || event.drawn? || event.job_id.value != jid

    showtime = event.showtime
    logger.info "event_id: #{lottery_event_id}, showtime_id: #{showtime.id} rule: #{event.lottery_rule}"
    logger.info event.draw ? 'DRAW' : 'NOT DRAW'
    logger.info "winners: #{event.winners.brief_names_text}"
    logger.info "last_f_code: #{event.last_failure_code.value}"
  end
end
