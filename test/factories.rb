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

  factory :appreciable_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    appreciable_user
  end

  factory :appreciable_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end

  factory :appreciation do
    association :by, factory: :appreciable_user
    to { [FactoryBot.create(:appreciable_user)] }
    message { Faker::Lorem.sentence(word_count: 20) }
  end
end
