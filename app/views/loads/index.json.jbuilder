json.array!(@loads) do |load|
  json.extract! load, :id, :weight, :state, :user_id, :machine_id, :machine_type
  json.url load_url(load, format: :json)
end
