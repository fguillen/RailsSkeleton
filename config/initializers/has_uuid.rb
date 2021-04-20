module HasUuid
  extend ActiveSupport::Concern

  included do
    before_validation :initialize_uuid, on: :create

    def initialize_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
