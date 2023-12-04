<%-- 
    Document   : ususarios
    Created on : Nov 29, 2023, 6:28:41 PM
    Author     : Usuario
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        h1, h2 {
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 30%;
            margin-top: 20px;
            float: left;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        form {
            display: inline;
            margin-right: 5px;
        }

        .details {
            margin-left: 40%;
        }
    </style>
</head>
<body>
    <h1>Lista de Usuarios</h1>

    <!-- Botón para regresar -->
    <a href="tu_pagina_anterior.jsp">Regresar</a>

    <!-- Formulario de búsqueda de usuario -->
    <form action="" method="get">
        <label for="usuarioBusqueda">Buscar Usuario:</label>
        <input type="text" id="usuarioBusqueda" name="usuarioBusqueda">
        <input type="submit" value="Buscar">
    </form>

    <!-- Código Java para obtener la lista de usuarios -->
    <%
        List<String[]> usuarios = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
            Statement statement = connection.createStatement();

            // Obtener la consulta SQL dependiendo de si hay una búsqueda
            String sqlQuery = "SELECT idUsuario, usuario, correo FROM usuario;";
            String usuarioBusqueda = request.getParameter("usuarioBusqueda");
            if (usuarioBusqueda != null && !usuarioBusqueda.isEmpty()) {
                sqlQuery = "SELECT idUsuario, usuario, correo FROM usuario WHERE usuario LIKE '%" + usuarioBusqueda + "%';";
            }

            ResultSet resultSet = statement.executeQuery(sqlQuery);

            while (resultSet.next()) {
                int idUsuario = resultSet.getInt("idUsuario");
                String usuario = resultSet.getString("usuario");
                String correo = resultSet.getString("correo");
                String[] userData = {String.valueOf(idUsuario), usuario, correo};
                usuarios.add(userData);
            }

            resultSet.close();
            statement.close();
            connection.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <!-- Verificar si hay usuarios antes de mostrar la tabla -->
    <% if (!usuarios.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>ID Usuario</th>
                    <th>Usuario</th>
                    <th>Correo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Iterar sobre la lista de usuarios y mostrar cada fila en la tabla -->
                <% for (String[] userData : usuarios) { %>
                    <tr>
                        <td><%= userData[0] %></td>
                        <td><%= userData[1] %></td>
                        <td><%= userData[2] %></td>
                        <td>
                            <form action="" method="get">
                                <input type="hidden" name="idUsuario" value="<%= userData[0] %>">
                                <input type="submit" value="Ver Detalles">
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No hay usuarios disponibles.</p>
    <% } %>

    <!-- Código Java para mostrar detalles del usuario seleccionado -->
    <% String usuarioIdParam = request.getParameter("idUsuario");
       if (usuarioIdParam != null && !usuarioIdParam.isEmpty()) {
           try {
               int usuarioId = Integer.parseInt(usuarioIdParam);
               Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
               Statement statement = connection.createStatement();
               ResultSet resultSet = statement.executeQuery("SELECT idUsuario, usuario, correo FROM usuario WHERE idUsuario = " + usuarioId + ";");

               if (resultSet.next()) {
                   int idUsuario = resultSet.getInt("idUsuario");
                   String usuario = resultSet.getString("usuario");
                   String correo = resultSet.getString("correo");

                   %>
                   <h2>Detalles del Usuario Seleccionado:</h2>
                   <ul>
                       <li>ID Usuario: <%= idUsuario %></li>
                       <li>Usuario: <%= usuario %></li>
                       <li>Correo: <%= correo %></li>
                   </ul>
                   <%
               }

               resultSet.close();
               statement.close();
               connection.close();

           } catch (Exception e) {
               e.printStackTrace();
           }
       }
    %>
</body>
</html>
