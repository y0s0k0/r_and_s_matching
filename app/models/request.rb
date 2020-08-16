class Request < ApplicationRecord
  belongs_to                    :client,     class_name: "User", foreign_key: "client_id"
  belongs_to                    :contractor, class_name: "User", foreign_key: "contractor_id", optional: true
  has_many                      :posts,      dependent: :destroy
  accepts_nested_attributes_for :posts,      allow_destroy: true
  has_many                      :messages
  acts_as_taggable
  enum condition: { now_accepting: 0, transaction_in_progress: 1, cancellation_application_cl: 2, cancellation_application_ct: 3, complete: 4 }

  validates :title,   presence: true, length: { maximum: 25 }
  validates :content, presence: true, length: { maximum: 200 }
  validates :reward,  presence: true, numericality: { greater_than_or_equal_to: 300 }, format: { with: /\A[0-9]+\z/ }
  validates :posts,   length: {maximum: 3}
end
