class Op::LotteryEventsController < ApplicationController
  layout 'layouts/panel'
  before_action :authenticate_admin
  before_action :set_showtime, only: [ :create, :update, :destroy ]
  before_action :set_lottery_event, only: [ :update, :destroy ]
  before_action :enable_render_op_links

  # POST /op/showtimes/1/lottery_event
  def create
    @lottery_event = LotteryEvent.new(lottery_event_params)
    @lottery_event.showtime = @showtime

    respond_to do |format|
      if @lottery_event.save
        format.html { redirect_to_showtime '成功创建抽奖事件。' }
      else
        flash[:alert] = '创建抽奖事件失败。'
        format.html { render 'op/showtimes/show' }
      end
    end
  end

  # PATCH/PUT /op/showtimes/1/lottery_event
  def update
    respond_to do |format|
      if @lottery_event.update(lottery_event_params)
        format.html { redirect_to_showtime '成功更新抽奖事件。' }
      else
        flash[:alert] = '更新抽奖事件失败。'
        format.html { render 'op/showtimes/show' }
      end
    end
  end

  # DELETE /op/showtimes/1/lottery_event
  def destroy
    respond_to do |format|
      if @lottery_event.drawn?
        format.html { redirect_to_showtime '取消抽奖失败，抽奖已结束。' }
      else
        @lottery_event.destroy
        format.html { redirect_to_showtime '成功取消抽奖。' }
      end
    end
  end

  private

  def set_showtime
    @showtime = Showtime.find(params[:showtime_id])
  end

  def set_lottery_event
    @lottery_event = @showtime.lottery_event
  end

  def lottery_event_params
    params.require(:showtime_id)
    params.require(:lottery_event).permit(:draws_at, :lottery_rule, :prizes_num)
  end

  def redirect_to_showtime(message)
    redirect_to op_showtime_path(@showtime), notice: message
  end
end
