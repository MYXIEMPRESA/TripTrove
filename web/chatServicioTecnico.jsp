<!DOCTYPE html>
<html>
    <head>
        <title>Start Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
        <h1>Chat application</h1>
        <input id="username_input" placeholder="Your username">
        <div id="output"></div>
        <input id="message_input" type="text">
        <button onclick="send()">Send message</button>
        <script src="js/websocket.js"></script>
         <iframe src="src/main/webapp/index.html" width="600" height="400"></iframe>
    </body>
</html>
