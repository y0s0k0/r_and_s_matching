json.id            @message.id
json.text          @message.text
json.picture       @message.picture.url
json.user_id       @message.user_id
json.user_avatar   @message.user.avatar.url
json.user_nickname @message.user.nickname
json.created_at    l(@message.created_at, format: :default)
