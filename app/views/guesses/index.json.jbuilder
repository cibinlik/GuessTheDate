json.array!(@guesses) do |guess|
  json.extract! guess, :id, :information_id, :answer, :kind, :delta, :score, :user_id
  json.url guess_url(guess, format: :json)
end
