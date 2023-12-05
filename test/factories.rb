FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :admin_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    admin_user
  end

  factory :front_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    front_user
  end

  factory :front_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :article do
    title { Faker::Lorem.sentence(word_count: 20) }
    body { Faker::Lorem.sentence(word_count: 20) }
    front_user
  end

  factory :log_book_event, :class => LogBook::Event  do
    differences { "Wadus Event" }
    association :historizable, factory: :article
  end

  factory :user_notifications_config do
    after(:build) do |user_notifications_config|
      if user_notifications_config.user.nil?
        create(:front_user, user_notifications_config: user_notifications_config)
      end
    end

    before(:create) do |user_notifications_config|
      if user_notifications_config.user.nil?
        create(:front_user, user_notifications_config: user_notifications_config)
      end
    end
  end
end
