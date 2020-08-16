class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).first.present?
  end
end
