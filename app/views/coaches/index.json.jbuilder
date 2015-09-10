json.array!(@coaches) do |coach|
  json.extract! coach, :id, :name, :city, :email
  json.url coach_url(coach, format: :json)
end
