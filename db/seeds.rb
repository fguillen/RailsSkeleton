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


Post.create!(
  front_user: FrontUser.find_by(email: email),
  title: "The title",
  body: "The body with more than 20 characters"
)