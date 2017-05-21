json.array! @messages do |message|
  json.(message.user, :name, :email, :phone)
  json.(message, :subject, :created_at, :text)
end
