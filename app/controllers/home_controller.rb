class HomeController < ApplicationController
  def index
    @showtimes = Showtime.ongoing
  end
end
