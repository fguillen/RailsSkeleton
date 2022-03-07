password = "p4sswORd"
email = "admin@example.com"

unless AdminUser.where(email: email).exists?
  AdminUser.create!(
    name: "Admin User",
    email: email,
    password: password,
    password_confirmation: password
  )
  puts "AdminUser created #{email}/#{password}"
end

password = "p4sswORd"
email = "front@example.com"

unless FrontUser.where(email: email).exists?
  FrontUser.create!(
    name: "Front User",
    email: email,
    password: password,
    password_confirmation: password
  )
  puts "FrontUser created #{email}/#{password}"
end

tags_example = ["shopping", "cooking", "hang-out", "love", "passion"]
10.times do
  Article.create!(
    front_user: FrontUser.find_by(email: email),
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraphs(number: rand(10..20)).join("\n\n"),
    tag_list: tags_example.sample(rand(0..3))
  )
end
