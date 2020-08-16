class Message < ApplicationRecord
  belongs_to :user
  belongs_to :request
  mount_uploader :picture, PictureUploader
  
  validates :text,    length: { maximum: 250 }
  validates :text,    presence: true, unless: :picture?
  validates :picture, presence: true, unless: :text?
end
