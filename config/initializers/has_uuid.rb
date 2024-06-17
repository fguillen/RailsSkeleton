module HasUuid
  extend ActiveSupport::Concern

  included do
    before_validation :initialize_uuid, on: :create

    def initialize_uuid
      self.uuid ||= ShortUUID.shorten(SecureRandom.uuid)
    end
  end
end
