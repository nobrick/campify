class Uni::CampusVotesController < ApplicationController
  before_action :authenticate_uni_user!
  before_action :set_showtime, only: [ :create ]

  # POST /uni/showtimes/1/vote
  def create
    university = University.find(params[:vote][:university_id])

    respond_to do |format|
      if @showtime.ballot && current_uni_user.vote_for(@showtime, university)
        format.html { redirect_to [ :uni, @showtime ], notice: '投票成功。' }
      else
        format.html do
          flash[:notice] = '投票失败。'
          render 'uni/showtimes/show'
        end
      end
    end
  end

  private

  def set_showtime
    @showtime = Showtime.find(params[:showtime_id])
  end
end
