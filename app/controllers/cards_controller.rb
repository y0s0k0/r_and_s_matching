class CardsController < ApplicationController
  require "payjp"
  before_action :set_card

  def new
    @card = Card.where(user_id: current_user.id).first
    redirect_to root_path if @card.present?
  end

  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    if params["payjp-token"].blank?
      redirect_to :new
    else
      customer = Payjp::Customer.create(
        description: "test",
        email: current_user.email,
        card: params["payjp-token"],
        metadata: {user_id: current_user.id}
      )
      @card = Card.new(user_id: current_user.id, payjp_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to root_path
      else
        render :new
      end
    end
  end

  def show
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      redirect_to :new 
    else
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      customer = Payjp::Customer.retrieve(card.payjp_id)
      @card_info = customer.cards.retrieve(card.card_id)
    end
  end
  
  def destroy
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      redirect_to action: "index", controller: "requests"
    else
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      customer = Payjp::Customer.retrieve(card.payjp_id)
      customer.delete
      card.delete
    end
      redirect_to action: "new"
  end

  private

  def set_card
    @card = Card.where(user_id: current_user.id) if Card.where(user_id: current_user.id).first.present?
  end
end
