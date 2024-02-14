<%@ page import="connectionDataBase.connection"%>
<html>
    <head>
        <style>
            @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap");
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                background-image: url("../CSS/img/fond.jpg");
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
            }


            h1 {
                text-align: center;
                font-size: 25px;
                color: white;
                font-family: "Poppins", sans-serif;
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

            .wrapper{
                width: 400px;
                margin: 50px 0 0 50px;
                background: rgba(0, 0, 0, .05);
                border: 2px solid rgba(255, 255, 255, 0);
                backdrop-filter: blur(20px);
                box-shadow: 0 0 10px rgba(0, 0, 0, .2);
                color: #fff;
                border-radius: 45px;
                padding:30px 40px;
                position: absolute;
                left: 0;
                top: 40%;
                transform: translateY(-50%);
            }

            .wrapper h1 {
                font-size: 36px;
                text-align: center;
            }

            .wrapper .input-box{
                position: relative;
                width: 100%;
                height: 50px;
                margin: 30px 0;
            }

            .input-box input{
                width: 100%;
                height: 100%;
                background: transparent;
                border: none;
                outline: none;
                border: 2px solid rgba(255, 255, 255, .2);
                border-radius: 40px;
                font-size: 16px;
                color: #fff;
                padding: 20px 45px 20px 20px;
            }

            .input-box input::placeholder{
                color: #fff;
            }

            .input-box i{
                position: absolute;
                right: 20px;
                top: 50%;
                transform:translateY(-50%);
                font-size: 20px;
            }

            .wrapper .btn{
                width: 100%;
                height: 45px;
                background: #000000;
                border: none;
                outline: none;
                border-radius: 40px;
                box-shadow: 0 0 10px rgba(0, 0,0, .1);
                cursor: pointer;
                font-size: 16px;
                color: #ffffff;
                font-weight: 600;
            }

            .wrapper .register-link{
                font-size: 14.5px;
                text-align: center;
                margin: 20px 0 15px;
            }
            .back-button {
                position: absolute;
                bottom: 20px;
                background-color: #000;
                color: #fff;
                border: none;
                border-radius: 50%;
                padding: 10px;
                cursor: pointer;
            }
            .loader {
                position: relative;
                border-style: solid;
                box-sizing: border-box;
                border-width: 40px 60px 30px 60px;
                border-color: #3760C9 #96DDFC #96DDFC #36BBF7;
                animation: envFloating 1s ease-in infinite alternate;
            }

            .loader:after {
                content: "";
                position: absolute;
                right: 62px;
                top: -40px;
                height: 70px;
                width: 50px;
                background-image: linear-gradient(#fff 45px, transparent 0),
                    linear-gradient(#fff 45px, transparent 0),
                    linear-gradient(#fff 45px, transparent 0);
                background-repeat: no-repeat;
                background-size: 30px 4px;
                background-position: 0px 11px , 8px 35px, 0px 60px;
                animation: envDropping 0.75s linear infinite;
            }

            @keyframes envFloating {
                0% {
                    transform: translate(-2px, -5px)
                }

                100% {
                    transform: translate(0, 5px)
                }
            }

            @keyframes envDropping {
                0% {
                    background-position: 100px 11px , 115px 35px, 105px 60px;
                    opacity: 1;
                }

                50% {
                    background-position: 0px 11px , 20px 35px, 5px 60px;
                }

                60% {
                    background-position: -30px 11px , 0px 35px, -10px 60px;
                }

                75%, 100% {
                    background-position: -30px 11px , -30px 35px, -30px 60px;
                    opacity: 0;
                }
            }
        </style>
        <title>administrador</title>
        <link rel="stylesheet" type="text/css" href="../CSS/app.css">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>

    <body>

        <div class="wrapper">
            <a href="../html/servicioTecnico.html">Regresar</a>
            <h1>Servicio al cliente</h1>
            <input id="username_input" placeholder="Your username" value="Servicio Tecnico" hidden>
            <div id="output"></div>
            <input id="message_input" type="text">
            <script src="../js/websocket.js"></script>
            <button onclick="send()">Send message</button> 
        </div>
        <div class="loader"></div>
    </body>
</html>

