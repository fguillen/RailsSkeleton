class Article < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid
  acts_as_taggable_on :tags
  has_one_attached :pic

  belongs_to :front_user

  validates :title, presence: true
  validates :body, length: { in: 20..65_535 }

  scope :order_by_recent, -> { order("created_at desc") }
end
