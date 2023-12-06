<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                width: 50%;
                margin-top: 20px;
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

        <!-- Formulario de búsqueda de usuario -->
        <form action="" method="get">
            <label for="usuarioBusqueda">Buscar Usuario:</label>
            <input type="text" id="usuarioBusqueda" name="usuarioBusqueda">
            <input type="submit" value="Buscar">
        </form>

        <!-- Código Java para obtener la lista de usuarios y roles -->
        <%
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "1234");
                statement = connection.createStatement();

                // Obtener la lista de usuarios
                String sqlQuery = "SELECT idUsuario, usuario, correo, idRol FROM usuario;";
                String usuarioBusqueda = request.getParameter("usuarioBusqueda");
                if (usuarioBusqueda != null && !usuarioBusqueda.isEmpty()) {
                    sqlQuery = "SELECT idUsuario, usuario, correo, idRol FROM usuario WHERE usuario LIKE '%" + usuarioBusqueda + "%';";
                }

                resultSet = statement.executeQuery(sqlQuery);

                List<String[]> usuarios = new ArrayList<>();

                while (resultSet.next()) {
                    int idUsuario = resultSet.getInt("idUsuario");
                    String usuario = resultSet.getString("usuario");
                    String correo = resultSet.getString("correo");
                    int idRol = resultSet.getInt("idRol");
                    String[] userData = {String.valueOf(idUsuario), usuario, correo, String.valueOf(idRol)};
                    usuarios.add(userData);
                }

                // Obtener la lista de roles
                List<String[]> roles = new ArrayList<>();
                resultSet = statement.executeQuery("SELECT idRol, nombreRol FROM rol;");
                while (resultSet.next()) {
                    int idRol = resultSet.getInt("idRol");
                    String nombreRol = resultSet.getString("nombreRol");
                    String[] rolData = {String.valueOf(idRol), nombreRol};
                    roles.add(rolData);
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
                    <th>Rol Actual</th>
                    <th>Cambiar Rol</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Iterar sobre la lista de usuarios y mostrar cada fila en la tabla -->
                <% for (String[] userData : usuarios) {%>
                <tr>
                    <td><%= userData[0]%></td>
                    <td><%= userData[1]%></td>
                    <td><%= userData[2]%></td>
                    <td>
                        <%-- Mostrar el rol actual del usuario --%>
                        <% for (String[] rolData : roles) {
                                if (userData[3].equals(rolData[0])) {
                        %>
                        <%= rolData[1]%>
                        <%     }
                                }%>
                    </td>
                    <td>
                        <!-- Formulario para cambiar el rol del usuario -->
                        <form action="" method="post">
                            <input type="hidden" name="idUsuario" value="<%= userData[0]%>">
                            <select name="nuevoRol">
                                <!-- Mostrar los roles en el combo -->
                                <% for (String[] rolData : roles) {%>
                                <option value="<%= rolData[0]%>" <%= userData[3].equals(rolData[0]) ? "selected" : ""%>><%= rolData[1]%></option>
                                <% }%>
                            </select>
                            <input type="submit" value="Cambiar Rol">
                        </form>
                    </td>
                    <td>
                        <form action="" method="get">
                            <input type="hidden" name="idUsuario" value="<%= userData[0]%>">
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
                    resultSet = statement.executeQuery("SELECT idUsuario, usuario, correo FROM usuario WHERE idUsuario = " + usuarioId + ";");

                    if (resultSet.next()) {
                        int idUsuario = resultSet.getInt("idUsuario");
                        String usuario = resultSet.getString("usuario");
                        String correo = resultSet.getString("correo");

        %>
        <h2>Detalles del Usuario Seleccionado:</h2>
        <ul>
            <li>ID Usuario: <%= idUsuario%></li>
            <li>Usuario: <%= usuario%></li>
            <li>Correo: <%= correo%></li>
        </ul>
        <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // Cerrar recursos
                try {
                    if (resultSet != null) {
                        resultSet.close();
                    }
                    if (statement != null) {
                        statement.close();
                    }
                    if (connection != null) {
                        connection.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <a href="administrador.html">Volver a Administrador</a>
    </body>
</html>
