require "test_helper"

class NotifierTest < ActionMailer::TestCase
  def test_admin_user_reset_password
    admin_user = FactoryBot.create(:admin_user, email: "admin@email.com")
    admin_user.perishable_token = "PERISHABLE-TOKEN"

    email = Notifier.admin_user_reset_password(admin_user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ["it@railsskeleton.com"], email.from
    assert_equal ["admin@email.com"], email.to
    assert_equal "[RailsSkeleton] Password reset", email.subject

    # write_fixture("/notifier/admin_user_reset_password.txt", email.body.encoded)
    assert_equal(File.read(fixture("/notifier/admin_user_reset_password.txt")), email.body.encoded)
  end
end
