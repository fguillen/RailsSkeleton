class AdminSession < Authlogic::Session::Base
  authenticate_with AdminUser

  def to_key
    new_record? ? nil : [send(self.class.primary_key)]
  end

  def persisted?
    false
  end
end
