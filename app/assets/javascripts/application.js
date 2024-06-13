//= require rails-ujs
//= require action_cable
//= require_self
//= require_tree .

(function() {
  this.App || (this.App = {});

  function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }

  const jwtToken = getCookie('jwt_token'); 
  if (jwtToken) {
    App.cable = ActionCable.createConsumer(`wss://chat-with-chums-1.onrender.com/cable?token=${jwtToken}`);
  } else {
    console.error("JWT token not found for Websocket connection");
  }
}).call(this);

document.addEventListener('DOMContentLoaded', () => {
  const urlParams = new URLSearchParams(window.location.search);
  const chatRoomId = urlParams.get('id');

  if (chatRoomId && App.cable) {
    App.chatChannel = App.cable.subscriptions.create(
      { channel: 'ChatChannel', chat_room_id: chatRoomId },
      {
        received: function(data) {
          const chatRoomElement = document.getElementById('chat-room');
          if (chatRoomElement) {
            chatRoomElement.insertAdjacentHTML('beforeend', `<div class="message">${data.username}: ${data.body}</div>`);
          }
        }
      }
    );
  }
});



