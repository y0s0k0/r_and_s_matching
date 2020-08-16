class MessagesController < ApplicationController
  before_action :set_request

  def index
    @messages = @request.messages.includes(:user)
    @message = Message.new
  end

  def create
    @message = @request.messages.new(message_params)
    if @message.save
      respond_to do |format|
        format.html {redirect_to request_messages_path(@request)}
        format.json
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :picture).merge(user_id: current_user.id)
  end

  def set_request
    @request = Request.find(params[:request_id])
  end
end
