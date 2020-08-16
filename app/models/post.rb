class Post < ApplicationRecord
  belongs_to :request
  mount_uploader :image, ImageUploader
  enum delete_instruction: { nothing: 0, run: 1 }
end
