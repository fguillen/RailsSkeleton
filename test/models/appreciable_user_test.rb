require "test_helper"

class AppreciableUserTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:appreciable_user).valid?
  end

  def test_slug_on_create
    appreciable_user = FactoryBot.build(:appreciable_user, name: "Appreciable User Title")
    assert_nil(appreciable_user.slug)

    appreciable_user.save!

    assert_equal("appreciable-user-title", appreciable_user.slug)
  end

  def test_primary_key
    appreciable_user = FactoryBot.create(:appreciable_user)

    assert_equal(appreciable_user, AppreciableUser.find(appreciable_user.slug))
  end

  def test_relations
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)
    appreciable_user_3 = FactoryBot.create(:appreciable_user)

    appreciation = FactoryBot.create(:appreciation, by: appreciable_user_1, to: [appreciable_user_2, appreciable_user_3])

    assert_equal(appreciable_user_1, appreciation.by)
    assert_equal(appreciable_user_2, appreciation.to.first)
    assert_equal(appreciable_user_3, appreciation.to.second)

    assert_equal(appreciation, appreciable_user_1.sent_appreciations.first)
    assert_equal(appreciation, appreciable_user_2.received_appreciations.first)
    assert_equal(appreciation, appreciable_user_3.received_appreciations.first)
  end

  def test_scope_order_by_name
    appreciable_user_1 = FactoryBot.create(:appreciable_user, name: "Calvario Juan")
    appreciable_user_2 = FactoryBot.create(:appreciable_user, name: "Arturo Buendia")
    appreciable_user_3 = FactoryBot.create(:appreciable_user, name: "Benedito Cifuentes")

    assert_primary_keys([appreciable_user_2, appreciable_user_3, appreciable_user_1], AppreciableUser.order_by_name)
  end
end
