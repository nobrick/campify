json.array!(@shows) do |show|
  json.extract! show, :id, :name, :category, :description, :proposer_id
  json.url op_show_url(show, format: :json)
end
