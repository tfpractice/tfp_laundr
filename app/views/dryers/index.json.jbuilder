json.array!(@dryers) do |dryer|
  json.extract! dryer, :id, :name, :position, :state, :user_id
  json.url dryer_url(dryer, format: :json)
end
