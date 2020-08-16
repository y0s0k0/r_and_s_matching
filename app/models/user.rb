class User < ApplicationRecord
  has_one        :card
  has_many       :client_requests,     class_name: "Request", foreign_key: "client_id"
  has_many       :contractor_requests, class_name: "Request", foreign_key: "contractor_id"
  has_many       :messages
  mount_uploader :avatar, AvatarUploader
  
  validates :nickname, presence: true, length: { maximum: 8 }

  devise         :database_authenticatable, :registerable,
                 :recoverable, :rememberable, :validatable

  enum avatar_delete_instruction: { nothing: 0, run: 1 }

  # def update_without_password(params, *options)
  #   params.delete(:current_password)

  #   if params[:password].blank? && params[:password_confirmation].blank?
  #     params.delete(:password)
  #     params.delete(:password_confirmation)
  #   end

  #   result = update_attributes(params, *options)
  #   clean_up_passwords
  #   result
  # end
end
