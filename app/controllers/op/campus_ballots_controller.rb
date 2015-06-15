class Op::CampusBallotsController < ApplicationController
  layout 'layouts/panel'
  before_action :authenticate_admin
  before_action :set_showtime, only: [ :create, :update, :destroy ]
  before_action :set_ballot, only: [ :update, :destroy ]
  before_action :enable_render_op_links

  # POST /op/showtimes/1/ballot
  def create
    @ballot = CampusBallot.new(ballot_params)
    @ballot.showtime = @showtime

    respond_to do |format|
      if @ballot.save
        format.html { redirect_to_showtime '成功发起投票。' }
      else
        flash[:alert] = '发起投票失败。'
        format.html { render 'op/showtimes/show' }
      end
    end
  end

  # PATCH/PUT /op/showtimes/1/ballot
  def update
    respond_to do |format|
      if @ballot.update(ballot_params)
        format.html { redirect_to_showtime '成功更新投票。' }
      else
        flash[:alert] = '更新投票失败。'
        format.html { render 'op/showtimes/show' }
      end
    end
  end

  # DELETE /op/showtimes/1/ballot
  def destroy
    @ballot.destroy
    respond_to do |format|
      format.html do
        redirect_to_showtime '成功删除投票。'
      end
    end
  end

  private

  def set_showtime
    @showtime = Showtime.find(params[:showtime_id])
  end

  def set_ballot
    @ballot = @showtime.ballot
  end

  def ballot_params
    params.require(:showtime_id)
    params.require(:ballot).permit(:expires_at)
  end

  def redirect_to_showtime(message)
    redirect_to op_showtime_path(@showtime), notice: message
  end
end
