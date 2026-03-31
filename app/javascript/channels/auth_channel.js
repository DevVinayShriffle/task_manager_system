import Backbone from "backbone";
import Radio from "backbone.radio";

const channel = Radio.channel("auth");

channel.reply("login", (data) => {
  return fetch("/api/login", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  }).then(res => res.json());
});

export default channel;
