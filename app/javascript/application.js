// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import consumer from "./channels/consumer";

document.addEventListener("DOMContentLoaded", () => {
  console.log("start subscribe ChatChannel");
  let arr = [];
  consumer.subscriptions.create("ChatChannel", {
    received(data) {
      const chatResponse = document.getElementById("chat-response");
      if (data == null) {
        return;
      }
      console.log(data.index, data.content);
      arr[data.index] = data.content;
      // index番号を考慮しない版
      chatResponse.innerHTML += data.content || "";

      // index番号を考慮する版
      // chatResponse.innerHTML = arr.join("");
      if (data.status == "finished") {
        console.log("finished");
      }
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

    messageInput.value = "";
  });
});
