# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



#For one-time seeding
# User.destroy_all
# User.create!([{
#    username: 'test',
#    password: 'test876',
#    age: 0,
#    name: 'test user',
#    bio: 'test user for testing purposes',
#    zipcode: '10000',
#    personality_type: 'INFJ',
#    interests: 'coding, testing , documenting',
#    is_verified: true,
#    chat_groups: 'room 1',
#    is_online: true
# }])

# ChatRoom.destroy_all
# ChatRoom.create!([{
#    name: 'room 1',
#    create_by: 'test',
#    created_on: Date.new(2024,6,1),
#    is_public: true,
#    personality_types: 'INFJ, INFP',
#    chat_users: 'test',
#    announcements: 'This is a test chat room'
# }])

# Message.destroy_all
# Message.create!([{
#     description: 'This is a test message. Hello World!',
#     created_by: 'test',
#     time_stamp: DateTime.new(2024,6,1,3,7,2),
#     chat_rooms: 'room 1',
# }])


require 'faker'

personality_types = [
  { name: 'ISTJ', interests: ['Organization', 'Reliability', 'Planning'], compatible_personalities: ['ESTP', 'ESFP', 'ISTP', 'ISFP'] },
  { name: 'ISFJ', interests: ['Support', 'Tradition', 'Reliability'], compatible_personalities: ['ESTP', 'ESFP', 'ISTP', 'ISFP'] },
  { name: 'INFJ', interests: ['Vision', 'Empathy', 'Ethics'], compatible_personalities: ['ENFP', 'INFP', 'ENFJ', 'INFJ'] },
  { name: 'INTJ', interests: ['Vision', 'Strategy', 'Independence'], compatible_personalities: ['ENTP', 'INTP', 'ENTJ', 'INTJ'] },
  { name: 'ISTP', interests: ['Flexibility', 'Solving Problems', 'Independence'], compatible_personalities: ['ESTJ', 'ISTJ', 'ESTP', 'ISFP'] },
  { name: 'ISFP', interests: ['Harmony', 'Adaptability', 'Empathy'], compatible_personalities: ['ESFJ', 'ISFJ', 'ESFP', 'ISTP'] },
  { name: 'INFP', interests: ['Creativity', 'Idealism', 'Empathy'], compatible_personalities: ['ENFJ', 'INFJ', 'ENFP', 'INFP'] },
  { name: 'INTP', interests: ['Analysis', 'Logic', 'Curiosity'], compatible_personalities: ['ENTJ', 'INTJ', 'ENTP', 'INTP'] },
  { name: 'ESTP', interests: ['Action', 'Excitement', 'Resourcefulness'], compatible_personalities: ['ISTJ', 'ESTJ', 'ISTP', 'ISFP'] },
  { name: 'ESFP', interests: ['Excitement', 'Playfulness', 'Optimism'], compatible_personalities: ['ISFJ', 'ESFJ', 'ISTP', 'ISFP'] },
  { name: 'ENFP', interests: ['Creativity', 'Optimism', 'Empathy'], compatible_personalities: ['INFJ', 'ENFJ', 'INFP', 'ENFP'] },
  { name: 'ENTP', interests: ['Ingenuity', 'Debating', 'Curiosity'], compatible_personalities: ['INTJ', 'ENTJ', 'INTP', 'ENTP'] },
  { name: 'ESTJ', interests: ['Efficiency', 'Traditionalism', 'Honesty'], compatible_personalities: ['ISTP', 'ESTP', 'ISFJ', 'ESFJ'] },
  { name: 'ESFJ', interests: ['Support', 'Tradition', 'Community'], compatible_personalities: ['ISFP', 'ESFP', 'ISTJ', 'ESTJ'] },
  { name: 'ENFJ', interests: ['Inspiration', 'Empathy', 'Altruism'], compatible_personalities: ['INFJ', 'ENFJ', 'INFP', 'ENFP'] },
  { name: 'ENTJ', interests: ['Leadership', 'Strategy', 'Efficiency'], compatible_personalities: ['INTJ', 'ENTJ', 'INTP', 'ENTP'] }
]

personality_types.each do |personality|
  Personality.create(personality)
end

User.destroy_all
10.times do
  personality = personality_types.sample[:name]
  user = User.create(
    username: Faker::Internet.username,
    name: Faker::Name.name,
    age: Faker::Number.between(from: 18, to: 80),
    zipcode: Faker::Address.zip_code,
    personality_type: personality,
    interests: personality_types.find { |p| p[:name] == personality }[:interests],
    is_verified: Faker::Boolean.boolean,
    is_online: Faker::Boolean.boolean,
    bio: Faker::Lorem.paragraph,
    password_digest: Faker::Internet.password
  )
  if user
    user.update(picture: Faker::Avatar.image(slug: user.username, size: "50x60", format: "jpg"))
  end
end



# Seed data for chat rooms
ChatRoom.destroy_all
if defined?(personality_types) && personality_types.any?
  # Seed 5 new chat rooms
  5.times do
    personality = personality_types.sample[:name]
    admin_id = User.pluck(:id).sample
    chat_room = ChatRoom.create(
      name: "#{Faker::Lorem.word} #{personality}",
      created_on: Faker::Date.between(from: 1.year.ago, to: Date.today),
      personality_types: personality,
      is_public: Faker::Boolean.boolean,
      announcements: Faker::Lorem.sentence,
      admin_id: admin_id,
      direct_message: false
    )
    puts "Chat room '#{chat_room.name}' created with admin ID #{admin_id}"
  end
else
  puts "Error: personality_types is not defined or empty"
end


# Seed data for messages
Message.destroy_all
10.times do
  message = Message.create(
    body: Faker::Lorem.sentence,
    time_stamp: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
    chat_room_id: ChatRoom.pluck(:id).sample,
    user_id: User.pluck(:id).sample
  )
end



