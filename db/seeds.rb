# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

start_date = Date.today - 365
end_date = Date.today - 1
random_date = rand(start_date..end_date)

puts"Cleaning db"

Moodtracker.destroy_all
SuggestionsComment.destroy_all
Suggestion.destroy_all
Event.destroy_all
Question.destroy_all
User.destroy_all


puts"creating users"

sales1 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Sales",
  password: "secret"
)
sales2 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Sales",
  password: "secret"
)
sales3 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Sales",
  password: "secret"
)
sales4 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Sales",
  password: "secret"
)

marketing1 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Marketing",
  password: "secret"
)
marketing2 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Marketing",
  password: "secret"
)

marketing3 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Marketing",
  password: "secret"
)
marketing4 = User.create!(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.email,
  job_position: Faker::Job.position,
  location: Faker::Address.country,
  team: "Marketing",
  password: "secret"
)

admin1 = User.create!(
  first_name: "Agnes",
  last_name: "Vincze",
  email: "agnes.vincze@glowork.online",
  admin: true,
  job_position: "Sales Manager",
  team: "Sales",
  location: Faker::Address.country,
  password: "GloWork2025"
)
admin2 = User.create!(
  first_name: "Mimi",
  last_name: "James",
  email: "admin2@glowork.online",
  admin: true,
  job_position: "Marketing Manager",
  team: "Marketing",
  location: Faker::Address.country,
  password: "GloWork2025"
)

user = User.create!(
  first_name: "Stefano",
  last_name: "Gioia",
  email: "ste.gioia@glowork.online",
  admin: false,
  job_position: "Employee",
  team: "Sales",
  location: Faker::Address.country,
  password: "GloWork2025"
)

user2 = User.create!(
  first_name: "Paul",
  last_name: "Holmes",
  email: "user2@glowork.online",
  admin: false,
  job_position: "Employee",
  team: "Sales",
  location: Faker::Address.country,
  password: "GloWork2025"
)

puts "#{User.count} users created"
puts"creating moodtrackers"

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: user
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: user2
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: admin2
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: admin1
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: sales1
  )
end
100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: sales2
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: marketing1
  )
end

100.times do
  Moodtracker.create!(
    mood: (1..3).to_a.sample,
    date: rand(start_date..end_date),
    user: marketing2
  )
end

puts "#{Moodtracker.count} moodtracker created"
puts "creating suggestions"

suggestion1 = Suggestion.create!(
  suggestion: "Summer Fridays",
  date: rand(start_date..end_date),
  actioned: true
)
suggestion2 = Suggestion.create!(
  suggestion: "Mental health training for managers",
  date: rand(start_date..end_date),
  actioned: true
)
suggestion3 = Suggestion.create!(
  suggestion: "4 day weeks",
  date: rand(start_date..end_date),
  actioned: false
)
puts "#{Suggestion.count} suggestions created"
puts "creating comments"

comment1 = SuggestionsComment.create!(
  comment: "Amazing idea!",
  user: sales1,
  suggestion: suggestion1
)
comment2 = SuggestionsComment.create!(
  comment: "Love it",
  user: sales2,
  suggestion: suggestion1
)
comment3 = SuggestionsComment.create!(
  comment: "That'll be so useful",
  user: sales3,
  suggestion: suggestion2
)
comment4 = SuggestionsComment.create!(
  comment: "lol",
  user: sales1,
  suggestion: suggestion3
)
puts "#{SuggestionsComment.count} suggestions_comments created"

puts "Creating Events..."

Event.create!(event_name: "Office party", start_date: DateTime.new(2025, 6, 4, 18, 0, 0), end_date: DateTime.new(2025, 6, 4, 21, 0, 0), location: "London", user: admin1)
Event.create!(event_name: "Catch-up Meeting", start_date: DateTime.new(2025, 6, 27, 14, 0, 0), end_date: DateTime.new(2025, 6, 27, 16, 0, 0), location: "Liverpool", user: admin1)
Event.create!(event_name: "Summer Meeting", start_date: DateTime.new(2025, 8, 10, 11, 0, 0), end_date: DateTime.new(2025, 8, 10, 12, 0, 0), location: "Manchester", user: admin1)

puts "#{Event.count} events created"
