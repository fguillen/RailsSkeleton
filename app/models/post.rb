class Post < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user

  validates :title, presence: true
  validates :body, length: { in: 20..500 }

  scope :order_by_recent, -> { order("created_at desc") }
end
