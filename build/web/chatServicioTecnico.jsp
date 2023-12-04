<!-- chatServivioTecnico.jsp -->
<%@ page import="javax.websocket.*" %>
<html>
    <head>
        <title>Chat Servicio T�cnico</title>
    </head>
    <body>
        <h1>Chat Servicio T�cnico</h1>
        <input type="text" id="messageInput" placeholder="Escribe tu mensaje">
        <button onclick="sendMessage()">Enviar</button>
        <div id="chatMessages"></div>
        
        <script>
            var socket = new WebSocket("ws://localhost:8090/TripTrove/chat");

            socket.onopen = function (event) {
                // L�gica cuando la conexi�n se abre
            };

            socket.onmessage = function (event) {
                var receivedMessage = event.data;
                addMessageToChat(receivedMessage);
            };

            socket.onclose = function (event) {
                // L�gica cuando la conexi�n se cierra
            };

            function sendMessage() {
                var messageInput = document.getElementById("messageInput");
                var message = messageInput.value;
                socket.send(message);
                messageInput.value = "";
            }

            function addMessageToChat(message) {
                var chatMessages = document.getElementById("chatMessages");
                var messageElement = document.createElement("div");
                messageElement.textContent = message;
                chatMessages.appendChild(messageElement);
            }
        </script>
    </body>
</html>
