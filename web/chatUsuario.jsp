<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <%
        //PROTECCION
        String nom_usuario = (String) session.getAttribute("usuario");
        String com_usuario = nom_usuario;
        String id_usuario = "2";
        String usuarioTecnio = "servicioTecnico";

        Connection conexion = null;
        Statement statement = null;
        ResultSet resultado = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "1234");
            statement = conexion.createStatement();

            String sql = "SELECT idUsuario FROM usuario WHERE usuario = '" + nom_usuario + "'";
            resultado = statement.executeQuery(sql);
            com_usuario = resultado.getString("contra");

        } catch (SQLException | ClassNotFoundException error) {
            out.print(error.toString());
    %>

    <body>

        <h1>Chat de <%=nom_usuario%></h1>
        <h2>con <%=com_usuario%></h2>


        <div id="output"></div>

        <input id="username_to" type="text" value="<%=id_usuario%>" hidden>
        <input id="nom_to" type="text" value="<%=usuarioTecnio%>" hidden>
        <input id="message_in" type="text">
        <input id="username_in" typse="text" value="<%=com_usuario%>" hidden>
        <input id="nom_in" type="text" value="<%=nom_usuario%>" hidden>
        <button onclick="send()">Enviar</button>

        <script src="websocket.js"></script>

    </body>
</html>
