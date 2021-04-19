class AppreciableSession < Authlogic::Session::Base
  authenticate_with AppreciableUser

  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def persisted?
    false
  end
end
