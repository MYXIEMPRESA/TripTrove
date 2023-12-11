<!DOCTYPE html>

<html>
    <head>
        <title>WEBSOCKET</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width">
    </head>
    <body>
        <p></p>
        <p></p>
        <div>
            <h4>Mensaje: </h4>
            <input type="text" id="messageinput"/>
        </div>
        <div>
            <p></p>
            <p></p>
            <button type="button" onclick="openSocket();" >Open</button>
            <button type="button" onclick="send();" >Send</button>
            <button type="button" onclick="closeSocket();" >Close</button>
        </div>
        <p></p>
        <p></p>
        <!-- Las respuestas del servidor se escriben aquí -->
        <div id="messages"></div>

        <!-- Script para utilizar el WebSocket  -->
        <script type="text/javascript">
            var webSocket;
            var messages = document.getElementById("messages");

            function openSocket() {
                // Ensure only one connection is open at a time
                if (webSocket && webSocket.readyState !== WebSocket.CLOSED) {
                    writeResponse("WebSocket ya está abierto.");
                    return;
                }
                // Create a new instance of WebSocket
                // Update the URL to use the correct context path for your application
                webSocket = new WebSocket("ws://localhost:8080/TripTrove/proceso");

                webSocket.onopen = function (event) {
                    writeResponse("WebSocket abierto");
                };

                webSocket.onmessage = function (event) {
                    writeResponse(event.data);
                };

                webSocket.onclose = function (event) {
                    writeResponse("Connection closed");
                };

                webSocket.onerror = function (error) {
                    console.error('WebSocket Error: ', error);
                };
            }

            /**
             * Send the value of the text input to the server
             */
            function send() {
                var text = document.getElementById("messageinput").value;

                if (webSocket && webSocket.readyState === WebSocket.OPEN) {
                    webSocket.send(text);
                } else {
                    writeResponse("WebSocket no está abierto. Por favor, abre la conexión antes de enviar.");
                }
            }

            function closeSocket() {
                if (webSocket) {
                    webSocket.close();
                } else {
                    writeResponse("WebSocket no está definido.");
                }
            }

            function writeResponse(text) {
                messages.innerHTML += "<br/>" + text;
            }
        </script>

    </body>
</html>
