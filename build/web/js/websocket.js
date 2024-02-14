var serverIP = "myxitech.gerdoc.com"; // Asegúrate de que no hay espacios al inicio
var wsURI = "ws://" + serverIP + ":8080/DishifyMx/chat";


var websocket = new WebSocket(wsURI);
console.log("WebSocket readyState: " + websocket.readyState);

websocket.onopen = function() {
    onOpen();
};

websocket.onmessage = function(evnt) {
    onMessage(evnt);
};

websocket.onerror = function(event) {
    console.error("WebSocket error:", event.message);
};

websocket.onclose = onClose;

function onOpen() {
    console.log("Opened connection: " + wsURI);
}

function onClose() {
    console.log("Closed connection: " + wsURI);
}

function onMessage(event) {
    console.log(event);
    display(event.data);
}

function display(dataString) {
    var data = JSON.parse(dataString);
    var contentMessage = data.conten + "</p>";
    document.getElementById("output").innerHTML += contentMessage + "</br>";
}

function send() {
    if (websocket.readyState === WebSocket.OPEN) {
        var message = document.getElementById("message_input").value;
        var username = document.getElementById("username_input").value;
        var json = {
            "conten":username+ ": " + message,
            "userName": username
        };
        console.log("Sending " + message);
        websocket.send(JSON.stringify(json));
    } else {
        console.error("WebSocket connection is not open.");
    }
}