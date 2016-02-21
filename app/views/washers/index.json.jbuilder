json.array!(@washers) do |washer|
  json.extract! washer, :id, :name, :position, :type, :state, :user_id
  json.url washer_url(washer, format: :json)
end
