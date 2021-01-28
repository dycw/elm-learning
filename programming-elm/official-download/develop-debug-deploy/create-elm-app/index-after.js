/***
 * Excerpted from "Programming Elm",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit http://www.pragmaticprogrammer.com/titles/jfelm for more book information.
 ***/
import "./main.css";
import { Elm } from "./Picshare.elm";
import * as serviceWorker from "./serviceWorker";

var app = Elm.Picshare.init({
  node: document.getElementById("root"),
});

app.ports.listen.subscribe(listen);

function listen(url) {
  var socket = new WebSocket(url);

  socket.onmessage = function (event) {
    app.ports.receive.send(event.data);
  };
}

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
