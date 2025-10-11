5.times do
  first_name = Faker::Name.first_name
  User.create!(first_name:, last_name: Faker::Name.last_name, email: "#{first_name}@test.com")
end

20.times do
  Blog.create!(title: Faker::Book.title, description: Faker::Lorem.paragraphs(number: 3), user: User.find(User.ids.sample))
end
