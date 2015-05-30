class Uni::ProfileController < ApplicationController
  before_action :authenticate_uni_user!
  def show
    @showtimes = Showtime.enrolled_by(current_uni_user)
  end
end
