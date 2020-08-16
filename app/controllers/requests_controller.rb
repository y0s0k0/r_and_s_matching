class RequestsController < ApplicationController
  before_action :set_card, only: [:new, :update, :pay_confirm, :pay]
  
  require "payjp"

  def index
    @requests = Request.where.not(condition: 4).where(client_id: current_user.id).or(Request.where.not(condition: 4).where(contractor_id: current_user.id)).or(Request.where(condition: 0))
    if params[:tag_name]
      @requests = @requests.tagged_with("#{params[:tag_name]}")
    end
  end

  def new
    if @card
      @request = Request.new
      3.times {@request.posts.build}
    else
      redirect_to new_card_path
    end
  end

  def create
    @request = Request.new(request_params.merge(set_client))
    @request.posts.each do |post|
      if post.image_url == nil
        post.destroy
      end
    end
    if @request.save
      redirect_to root_path, notice: "新規依頼を作成しました。"
    else
      flash.now[:alert] = "依頼を作成できませんでした。"
      render :new
    end
  end

  def show
    if request.env["HTTP_REFERER"].match(/\/requests\/\d+/)
      render :edit
    else 
      @request = Request.find(params[:id])
    end
  end

  def edit
    @request = Request.find(params[:id])
    @posts = @request.posts
    @posts.each do |post|
      @post = post
    end
    count = @posts.count
    (3 - count).times {@request.posts.build}
  end

  def update
    @path = update_condition(request.referer)
    if @path[:controller] == "requests"
      if (params[:request][:type] == "edit")
        @request = Request.find(params[:id])
        if @request.update(request_params)
          @request.posts.each do |post|
            if post.delete_instruction == "run" || post[:image] == nil
              post_delete = Post.find(post.id)
              post_delete.destroy
            end
          end
          redirect_to root_path, notice: "依頼内容を変更しました。"
        else
          flash.now[:alert] = "依頼内容が変更できませんでした。"
          render :edit
        end
      elsif (params[:request][:type] == "show")
        @request = Request.find(params[:id])
        if @card.blank?
          redirect_to new_card_path
        elsif current_user.id == @request.client_id
          redirect_to root_path, alert: "自分の依頼を受けることはできません。"
        else
          if @request.update(set_contractor)
            redirect_to request_messages_path(request_id: @request.id), notice: "依頼を受諾しました。"
          else
            flash.now[:alert] = "依頼を受諾できませんでした。"
            render :show
          end
        end
      end
    else
      if @path[:action] == "index"
        @request = Request.find(params[:id])
        if params[:type] == "cancellation_application"
          if @request.client_id == current_user.id
            if @request.update(set_cancellation_application_cl)
              redirect_to root_path, notice: "取引中止を申請しました。"
            else
              flash.now[:alert] = "取引中止が申請できませんでした。"
              render request_messages_path
            end
          end
          if @request.contractor_id == current_user.id
            if @request.update(set_cancellation_application_ct)
              redirect_to root_path, notice: "取引中止を申請しました。"
            else
              flash.now[:alert] = "取引中止が申請できませんでした。"
              render request_messages_path
            end
          end
        elsif params[:type] == "transaction_in_progress"
          if @request.update(set_transaction_in_progress)
            redirect_to root_path, notice: "取引の中止を拒否しました。"
          else
            flash.now[:alert] = "取引の中止を拒否できませんでした。"
            render request_messages_path
          end
        elsif params[:type] == "now_accepting"
          if @request.update(set_now_accepting)
            redirect_to root_path, notice: "取引の中止を承諾しました。"
          else
            flash.now[:alert] = "取引の中止を承諾できませんでした。"
            render request_messages_path
          end
        else
          render request_messages_path
        end
      end
    end
  end

  def destroy
    @request = Request.find(params[:id])
    if @request.client_id == current_user.id
      if @request.destroy
        redirect_to root_path, notice: "依頼を削除しました。"
      else
        flash.now[:alert] = "依頼を削除できませんでした。"
        render edit_request_path
      end
    else
      flash.now[:alert] = "他人の依頼は削除できません。"
      render root_path
    end
  end

  def contractor_list
    @contractor_requests = Request.where(contractor_id: current_user.id)
    if params[:tag_name]
      @contractor_requests = @contracts.tagged_with("#{params[:tag_name]}")
    end
  end

  def client_list
    @client_requests = Request.where(client_id: current_user.id)
    if params[:tag_name]
      @client_requests = @client_requests.tagged_with("#{params[:tag_name]}")
    end
  end

  def pay_confirm
    @request = Request.find(params[:id])
    if @card.blank?
      redirect_to :new, alert: "カード情報が登録されていません。支払い方法の登録を済ませてください。"
    else
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      customer = Payjp::Customer.retrieve(@card.payjp_id)
      @card_info = customer.cards.retrieve(@card.card_id)
    end
  end

  def pay
    if @card.blank?
      redirect_to root_path, alert: "カード情報が登録されていません。支払い方法の登録を済ませてください。"
    else
      @request = Request.find(params[:id])
      @contractor = User.find(@request.contractor_id)
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
      Payjp::Charge.create(
        amount: @request.reward,
        customer: @card.payjp_id,
        currency: "jpy"
      )
      if @request.update(set_complete)
        redirect_to root_path, notice: "取引が完了しました。"
      else
        flash.now[:alert] = "取引を完了できませんでした。"
        render request_messages_path
      end
    end
  end

  private
  
  def request_params
    params.require(:request).permit(
      :title,
      :content,
      :reward,
      :tag_list,
      posts_attributes: [:id, :image, :image_cache, :delete_instruction])
  end

  def posts_params
    request_params[:posts_attributes]
  end

  def update_condition(referer)
    Rails.application.routes.recognize_path(referer)
  end

  def set_client
    {client_id: current_user.id}
  end

  def set_contractor
    {contractor_id: current_user.id, condition: 1}
  end

  def set_now_accepting
    {condition: 0}
  end
  
  def set_transaction_in_progress
    {condition: 1}
  end
  
  def set_cancellation_application_cl
    {condition: 2}
  end

  def set_cancellation_application_ct
    {condition: 3}
  end
  
  def set_complete
    {condition: 4}
  end
end
