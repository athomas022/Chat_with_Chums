//= require rails-ujs
//= require action_cable
//= require_self
//= require_tree 

(function() {
    this.App || (this.App = {});
    App.cable = ActionCable.createConsumer();
  }).call(this);


const urlParams = new URLSearchParams(window.location.search);
const chatRoomId = urlParams.get('id');

App.chatChannel = App.cable.subscriptions.create({ channel: 'ChatChannel', chat_room_id: chatRoomId }, {
    received: function(data) {
      $('#chat-room').append('<div class="message">' + data.username + ': ' + data.body + '</div>');
    }
  });