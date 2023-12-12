<html>
    <head>
        <style>
            body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    background-color: #f5f5f5;
}

h1 {
    color: #333;
}

#username_input, #message_input {
    padding: 10px;
    margin: 5px 0;
    border: 1px solid #ddd;
    border-radius: 4px;
    width: 300px;
}

#output {
    width: 300px;
    height: 300px;
    border: 1px solid #ddd;
    margin-bottom: 5px;
    padding: 10px;
    overflow-y: auto;
    background-color: #fff;
}

button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}

a {
    color: #007bff;
    text-decoration: none;
    margin-top: 10px;
}

a:hover {
    text-decoration: underline;
}

        </style>
        <title>administrador</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
     <body>
        <a href="principal.jsp">Regresar</a>
        <h1>Servicio al cliente</h1>
        <input id="username_input" placeholder="Your username">
        <div id="output"></div>
        <input id="message_input" type="text">
        <script src="websocket.js"></script>
        <button onclick="send()">Send message</button> 
        <button  type="submit"  name="accion" id="accion" value="enviar">Terminar</button>
    </body>
</html>