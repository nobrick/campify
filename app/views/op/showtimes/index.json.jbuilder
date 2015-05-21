json.array!(@showtimes) do |showtime|
  json.extract! showtime, :id, :show_id, :title, :description, :starts_at, :ends_at, :ongoing
  json.url showtime_url(showtime, format: :json)
end
