class AppreciableUser < ApplicationRecord
  self.primary_key = :slug

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = AppreciableSession
  end

  has_many :authorizations, class_name: "AppreciableAuthorization", :dependent => :destroy
  has_many :sent_appreciations, class_name: "Appreciation", foreign_key: "by_slug", dependent: :nullify
  has_and_belongs_to_many :received_appreciations,
      class_name: "Appreciation",
      foreign_key: "appreciable_user_slug",
      association_foreign_key: "appreciation_uuid",
      join_name: "appreciable_users_appreciations",
      dependent: :nullify

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => { :with => RubyRegex::Email }
  validates :slug, presence: true, uniqueness: true

  before_validation :initialize_slug

  scope :order_by_recent, -> { order("created_at desc, slug desc") }
  scope :order_by_name, -> { order("name asc, slug desc") }

  private

  def initialize_slug
    self.slug ||= name.parameterize
  end
end
