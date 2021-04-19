require "test_helper"

class AppreciationTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:appreciation).valid?
  end

  def test_validations
    appreciation = FactoryBot.build(:appreciation)
    assert(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, message: nil)
    refute(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, message: "")
    refute(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, message: "A" * 6)
    refute(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, message: "A" * 501)
    refute(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, message: "A" * 30)
    assert(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, by: nil)
    refute(appreciation.valid?)

    # appreciation = FactoryBot.build(:appreciation, to: nil)
    # refute(appreciation.valid?)

    appreciation = FactoryBot.build(:appreciation, to: [])
    refute(appreciation.valid?)
  end

  def test_uuid_on_create
    appreciation = FactoryBot.build(:appreciation)
    assert_nil(appreciation.uuid)

    appreciation.save!

    assert_not_nil(appreciation.uuid)
  end

  def test_primary_key
    appreciation = FactoryBot.create(:appreciation)

    assert_equal(appreciation, Appreciation.find(appreciation.uuid))
  end

  def test_relations
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciable_user_to_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_to_2 = FactoryBot.create(:appreciable_user)

    appreciation = FactoryBot.create(:appreciation, by: appreciable_user, to: [appreciable_user_to_1, appreciable_user_to_2])

    assert_equal(appreciable_user, appreciation.by)
    assert_equal(appreciable_user_to_1, appreciation.to.first)
    assert_equal(appreciable_user_to_2, appreciation.to.second)
  end

  def test_scope_by
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)
    appreciable_user_3 = FactoryBot.create(:appreciable_user)

    appreciation_1 = FactoryBot.create(:appreciation, by: appreciable_user_1, to: [appreciable_user_2, appreciable_user_3])
    appreciation_2 = FactoryBot.create(:appreciation, by: appreciable_user_2, to: [appreciable_user_3])

    assert_primary_keys([appreciation_1], Appreciation.by(appreciable_user_1))
    assert_primary_keys([appreciation_2], Appreciation.by(appreciable_user_2))
    assert_primary_keys([], Appreciation.by(appreciable_user_3))
  end

  def test_scope_to
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)
    appreciable_user_3 = FactoryBot.create(:appreciable_user)

    appreciation_1 = FactoryBot.create(:appreciation, by: appreciable_user_1, to: [appreciable_user_2, appreciable_user_3])
    appreciation_2 = FactoryBot.create(:appreciation, by: appreciable_user_2, to: [appreciable_user_3])

    assert_primary_keys([], Appreciation.to(appreciable_user_1))
    assert_primary_keys([appreciation_1], Appreciation.to(appreciable_user_2))
    assert_primary_keys([appreciation_1, appreciation_2].sort, Appreciation.to(appreciable_user_3).sort)
  end

  def test_pic
    appreciation = FactoryBot.create(:appreciation)
    appreciation.pic.attach(io: File.open("#{FIXTURES_PATH}/files/yourule.png"), filename: "yourule.png")

    assert(appreciation.pic.attached?)
  end

  def test_slack_notification
    appreciation = FactoryBot.create(:appreciation)

    Appreciations::SlackNotificationService.expects(:perform).with(appreciation)

    appreciation.slack_notification
  end
end
