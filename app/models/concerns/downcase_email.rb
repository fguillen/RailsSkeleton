module DowncaseEmail
  extend ActiveSupport::Concern

  included do
    before_validation :downcase_email

    def downcase_email
      self.email = email.downcase if email.present?
    end
  end
end
