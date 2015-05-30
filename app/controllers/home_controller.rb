class HomeController < ApplicationController
  def index
    @showtime = Showtime.ongoing
  end
end
