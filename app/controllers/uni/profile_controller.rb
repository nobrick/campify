class Uni::ProfileController < ApplicationController
  before_action :authenticate_uni_user!
  def show
    @showtimes_enrolled = Showtime.enrolled_by(current_uni_user)
    @showtimes_voted = Showtime.voted_by(current_uni_user)
  end
end
