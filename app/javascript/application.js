// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import consumer from "./channels/consumer";

document.addEventListener("DOMContentLoaded", () => {
  console.log("start subscribe ChatChannel");
  consumer.subscriptions.create("ChatChannel", {
    received(data) {
      // TODO:サーバサイドから切断できる？
      // data = {type:"message", text="犬"}
      // data = {type:"disconnect"}
      console.log(data);
      const chatResponse = document.getElementById("chat-response");
      if (data == null) {
        return;
      }
      chatResponse.innerHTML += data;
    },
  });

  const form = document.getElementById("chat-form");
  const messageInput = document.getElementById("chat-message");
  const chatResponse = document.getElementById("chat-response");

  form.addEventListener("submit", function (e) {
    e.preventDefault();
    const message = messageInput.value;
    chatResponse.innerHTML = ""; // レスポンスエリアをクリア

    // ここでAjaxを使用してサーバーにメッセージを送信し、レスポンスを取得
    fetch("/chats", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name=csrf-token]").content,
      },
      body: JSON.stringify({ message: message }),
    });
    // .then((response) => response.json())
    // .then((data) => {
    //   displayTypingAnimation(data.response, "chat-response", 50); // Typing Animationを表示
    // });

    messageInput.value = ""; // メッセージ入力をクリア
  });
});
