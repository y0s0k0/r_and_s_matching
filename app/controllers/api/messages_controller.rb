class Api::MessagesController < ApplicationController
  def index
    @request = Request.find(params[:request_id])
    last_message_id = params[:id].to_i
    @messages = @request.messages.includes(:user).where("id > #{last_message_id}")
    @current_user_id = current_user.id
  end
end