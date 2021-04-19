require "test_helper"

class FrontUserTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:front_user).valid?
  end

  def test_uuid_on_create
    front_user = FactoryBot.build(:front_user)
    assert_nil(front_user.uuid)

    front_user.save!

    assert_not_nil(front_user.uuid)
  end

  def test_primary_key
    front_user = FactoryBot.create(:front_user)

    assert_equal(front_user, FrontUser.find(front_user.uuid))
  end

  def test_scope_order_by_recent
    front_user_1 = FactoryBot.create(:front_user, created_at: "2021-04-01")
    front_user_2 = FactoryBot.create(:front_user, created_at: "2021-04-02")
    front_user_3 = FactoryBot.create(:front_user, created_at: "2021-04-03")

    assert_primary_keys([front_user_3, front_user_2, front_user_1], FrontUser.order_by_recent)
  end
end
