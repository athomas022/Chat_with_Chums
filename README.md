# Unit 4 Project - Chat with Chums
Access this app on [Render](https://chat-with-chums-1.onrender.com/)

## Technologies Used
Rails (backend and frontend), ActionCable(for WebSockets), Javascript, CSS, PostgresQL and ChatGpt (for debugging and CSS support)

## Installation Instructions
Access this app on [Render](https://chat-with-chums-1.onrender.com/)

## User Stories
- As a user, I'd like to sign up for Chat for Chums both on my web-browser or my phone and log out.
- As a user, I'd like to take the personality test and be able to find out which personality I am, what interests I lean towards and which personalities I am compatible with.
- As a user, I'd like to identify other people's personalities and connect with them either in chat rooms or in direct messages.
- As a user, I'd like to be verified and connect with other verified users (and add them as my friend/block them).
- As a user, I'd like to search for chat rooms/groups that fit my interests and recommendation personality preferences and join them.
- As a user,  I'd like for my message history to be stored and available even when I log out.
- As a user, I'd like to keep track of my chats, my friends, interests etc.
- As a user, I'd like to see if folks have read my messages and when others are typing.
- As a user, I'd like to view the other users in the chat room and be able to click the profile.
- As a group admin, I'd like to create a chat room if I don't find a chat room that I like. I should be able to edit/delete the chat or add/remove members.
- As a user, I'd like to change my interests.
- As a group admin, I'd like to make announcements in the chat rooms.

## MVP
- Web-based and mobile app that has a landing page which describes the features of the app and has a nav bar to navigate to the different features of the app, including the sign-up/login page.
- A sign on page to register the user and allows for user authentication every time the user is logged in.
- A logout function in the nav bar so the user can log out.
- A profile page for the user, where the personal details, location, personality, interests, chat groups and friends are detailed. The profile page will allow the user to edit or delete their own profile.
- Display a list of the existing chat rooms, which users can search for based on keywords and join or leave the chat rooms.
- Real-time messaging features for both the chat room and direct messaging.
- Store the messages by users for every chat room/direct message chat.
- Search for users, click the user's profile and see their public details (such as location, personality type and interests). And be able to connect with them.
- Ability to see the users in a chat room.
- Users can create a chat room (and they become a group admin), edit the details, block users from joining, allow other users to join.
- Styling with Tailwind CSS for both web-browser and mobile devices.
- Utilize Ruby for the backend and frontend, SQL for the database and Websockets API for the real time messaging.

## Wireframes
- Landing page.
![image](https://media.git.generalassemb.ly/user/51651/files/3992dcaf-a360-4b6e-ad14-3a8e7b6961fb)
- Sign-up/Login page.
![image](https://media.git.generalassemb.ly/user/51651/files/8b41c4d6-cc2c-43a4-8761-cabd5741f383)
- My Profile page.
![image](https://media.git.generalassemb.ly/user/51651/files/75929ccf-d4cc-4146-8e16-dfdd47ea9222)
- Chat room index page.
![image](https://media.git.generalassemb.ly/user/51651/files/48fcedb8-6eac-48a5-9e1e-9297b74d33e9)
- Chat room.
![image](https://media.git.generalassemb.ly/user/51651/files/c5a63261-b6e0-4a96-840c-b75557292c83)
- Direct messaging.
![image](https://media.git.generalassemb.ly/user/51651/files/7ddc3792-3c93-4401-9552-f36897045099)


## Approach taken: Utilized the MVC setup with the 7 restful routes
1. Nagivation (Views and Navbar):
Utilized the following views to navigate between the pages:
- Welcome page: this was the root view for the app.
- About Us page: This details what the app is about.
- Test page: this routes the user to a 3rd party provider of the MBTI test to understand their personality.
- Chats: There is an index view which contains the chats (with users being able to search based on name of the chatroom). The users can view/join/leave a chat room. Viewing and joining a chat room directs the user to the chat where they can view/search for other users (in the sidebar) and see who is online in the chat group and direct message/start a DM with them and add them to their friends group. If a current user created the room, they can edit or delete the chat room.
- Navbar partial/template: This contains the links to the above pages but also when a user is logged in, it will display a link to their profile and a link to logout. If the user is not signed in, the user see the link to login in.
2. Schemas built (Models):
   Built the following schemas (for PostgresQL through Rails) for the user interaction etc.:
   - Users
   - Chat Rooms
   - Messages
   - Participants (utilzied as a join table to link chat rooms and users)    
3. Utilized the Active Record Associations (in Rails) to build relationships between the models/schema.
  ![image](https://media.git.generalassemb.ly/user/51651/files/9ee951e1-81d1-4972-8e21-26dbece97b49)
6. The user is authenticated for every route that is hit (except for the Welcome, About Us and Test routes) and logs info about the current_user.
7. Utilize all the 7 restful routes and CRUD across the app to navigate pages and query and retrieve from PostgresQL.


## Unsolved Problems / Major Hurdles:
### Major Hurdles:
1. Utilizing Rails and ruby for the first time and deploying some more complicated functionalities (such as Action Cable)
1. Authentication utilizing Devise-jwt. Devise provides a lot of authentication options which can conflict with each other. Moreover, because it was utilized with action cable, there was a lot more debugging required for token handling and authentication needed for Action Cable. Also, there were many sessions related errors that required debugging, including needing to clear the browser etc.
2. Action Cable without a JS based frontend; this meant additional debugging and customization. It also required additional setups (like redis for production deployment).
3. Tailwind CSS/Bootstrap would not work despite multiple debugging sessions and so had to resort to inline styling (and very basic styling).

### Unresolved Problems/Goals:
1. When deploying the app to render, there is an issue where a user can't do multiple logins (i.e., there is a username not valid error when the user logouts for the first time and tries to log back in). Inspite of multiple debugging efforts, this was not resolved on the date of submission.
2. The CSS for the chat room show page is not working well in the mobile view, inspite of multiple attempts to correct for it.
3. Because of the lack of a JS-based frontend, the real time messaging is not as smooth as it could be. The reciver of the message has to refresh the page to see the other user's messages. 
4. While the admin of the group can remove participants from the chat, they can not block users from joining, allow other users to join (this will be shifted to the stretch goal).


### Unresolved Stretch Goals:
- Allow the user to select additional interests in their profile.
- Have recommendations to chat rooms and other users in a user's profile based on their location, personality and interests.
- Make announcements in chat rooms that are available for a set amount of time.
- Ability to see whether the user and other users are online or not.
- Voice integration into the chat feature in a chat room or direct messaging.
- Ability to see whether other users have seen my message and if they are typing.
- Make chat rooms public or private.
- Styling: Enhanced styling (e.g., animations on the landing page etc.).
- Have the ability to verify the user and see other verified users in the app.
- A API driven personality test that spits out the MBTI for the user and saves this for the user.
- Have a suggested list of other MBTI personalities that they are compatible.

## References
- [Rails documentation](https://guides.rubyonrails.org/index.html).
- Medium articles for [PostgresQL setup with Rails](https://medium.com/@laasrisaid34/step-by-step-guide-to-creating-a-ruby-on-rails-application-with-postgresql-46fef05c212b), [Seeding the data using the faker gem](https://medium.com/@isaacfalkenstine/using-faker-in-a-rails-application-9f6667255b38), [Data types in Rails/ruby](https://jmknopf1007.medium.com/an-overview-of-the-rails-data-types-8686f5225d6f), [Action Cable authorization](https://itnext.io/actioncable-authentication-in-a-token-based-rails-api-f9cc4b8bf560), [Autentication support](https://medium.com/@tpstar/password-digest-column-in-user-migration-table-871ff9120a5), [Devise-JWT in rails](https://benmukebo.medium.com/user-authentication-app-in-ruby-on-rails-with-devise-jwt-tutorial-adabebebd83e), [Error handling](https://medium.com/@zahidensari116/7-ways-of-effective-error-handling-in-ruby-best-practices-and-strategies-a10454f4bd51), [Implementing Chat using Action Cable in Rails](https://bashiralhanshali.medium.com/how-to-implement-real-time-messaging-in-rails-6-using-action-cable-c8bfdde892ee), [Additional authentication references](https://medium.com/swlh/auth-with-json-web-tokens-bcrypt-part-i-rails-3afd71751ea) and [Searchbar in Rails](https://medium.com/swlh/creating-a-search-bar-for-a-rails-application-fbf5bfc47268).
-[Personality test](https://www.16personalities.com/free-personality-test).
- Youtube Videos for [Ruby on rails guide](https://www.youtube.com/watch?v=fmyvWz5TUWg&t=1569s), [Authorization](https://www.youtube.com/watch?v=Hb9WtQf9K60), [Seeding a Rails DB](https://www.youtube.com/watch?v=eR07DB-GUJ8) and [Action Cable](https://www.youtube.com/watch?v=GdbazkAczTo)
- Additional Devise documentation in [dev.to](https://dev.to/dhintz89/devise-and-jwt-in-rails-2mlj) and [github](https://github.com/waiting-for-dev/devise-jwt?tab=readme-ov-file)
- ChatGpt for debugging (including authentication, Action Cable, javascript for action cable and CSS errors)
- Referenced the CSS setup from my previous projects.
