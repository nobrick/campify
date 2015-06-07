class Uni::ShowtimesController < ApplicationController
  def index
    case params[:s_filter]
    when 'enrollable', 'enr'
      @showtimes = Showtime.enrollable
    when 'on_ballot', 'pk'
      @showtimes = Showtime.on_ballot
    else
      @showtimes = Showtime.ongoing
    end
  end

  def show
    @showtime = Showtime.find(params[:id])
  end
end
