class FrontSession < Authlogic::Session::Base
  authenticate_with FrontUser

  def to_key
    new_record? ? nil : [send(self.class.primary_key)]
  end

  def persisted?
    false
  end
end
