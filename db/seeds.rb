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
User.destroy_all
User.create!([{
   username: 'test',
   password: 'test876',
   age: 0,
   name: 'test user',
   bio: 'test user for testing purposes',
   zipcode: '10000',
   personality_type: 'INFJ',
   interests: 'coding, testing , documenting',
   is_verified: true,
   chat_groups: 'room 1',
   is_online: true
}])

ChatRoom.destroy_all
ChatRoom.create!([{
   name: 'room 1',
   create_by: 'test',
   created_on: Date.new(2024,6,1),
   is_public: true,
   personality_types: 'INFJ, INFP',
   chat_users: 'test',
   announcements: 'This is a test chat room'
}])

Message.destroy_all
Message.create!([{
    description: 'This is a test message. Hello World!',
    created_by: 'test',
    time_stamp: DateTime.new(2024,6,1,3,7,2),
    chat_rooms: 'room 1',
}])