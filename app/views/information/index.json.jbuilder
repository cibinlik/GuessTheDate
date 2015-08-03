json.array!(@information) do |information|
  json.extract! information, :id, :info, :month, :day, :year, :user_id
  json.url information_url(information, format: :json)
end
