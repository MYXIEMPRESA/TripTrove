<%@ page import="javax.websocket.*" %>
<html>
<head>
    <title>WebSocket Example</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 20px;
        }

        #message-container {
            border: 1px solid #ccc;
            padding: 10px;
            margin-top: 20px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
            overflow-y: scroll;
            height: 200px;
        }

        #input-container {
            margin-top: 20px;
        }

        #message-input {
            width: 200px;
            padding: 5px;
            margin-right: 10px;
        }

        #send-button {
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div>Web sockets</div>
    <div id="message-container"></div>
    
    <div id="input-container">
        <textarea id="message-input" placeholder="Escribe tu mensaje"></textarea>
        <button id="send-button" onclick="enviarMensaje()">Enviar</button>
    </div>

    <script>
        var i = 0;

        var socket = new WebSocket("ws://localhost:8080/TripTrove/webserversocket/gerdoc");

        socket.onopen = function (event) {
            var aux = crearMensaje();
            socket.send("{'de':'Nahum','para':'soporte','mensaje':'mensaje '" + i++ + "'}");
        };

        socket.onmessage = function (event) {
            mostrarMensaje(event.data);
        };

        socket.onclose = function (event) {
            console.log("onclose: ");
        };

        socket.onerror = function (event) {
            console.log("Error: " + event.data);
        };

        function crearMensaje() {
            return "{'de':'Nahum','para':'soporte','mensaje':'mensaje '" + i++ + "'}";
        }

        function mostrarMensaje(mensaje) {
            var messageContainer = document.getElementById("message-container");
            var newMessage = document.createElement("div");
            newMessage.textContent = mensaje;
            messageContainer.appendChild(newMessage);

            // Scroll hacia abajo para mostrar el �ltimo mensaje
            messageContainer.scrollTop = messageContainer.scrollHeight;
        }

        function enviarMensaje() {
            var messageInput = document.getElementById("message-input");
            var mensaje = messageInput.value.trim();

            if (mensaje !== "") {
                socket.send("{'de':'Nahum','para':'soporte','mensaje':'" + mensaje + "'}");
                messageInput.value = ""; // Limpiar el �rea de texto despu�s de enviar el mensaje
            }
        }
    </script>
</body>
</html>
