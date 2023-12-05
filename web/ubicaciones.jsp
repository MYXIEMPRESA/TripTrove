<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Ubicaciones</title>
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
            width: 80%;
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
    <h1>Lista de Ubicaciones</h1>

    <!-- Formulario de búsqueda de ubicación -->
    <form action="" method="get">
        <label for="ubicacionBusqueda">Buscar Ubicación:</label>
        <input type="text" id="ubicacionBusqueda" name="ubicacionBusqueda">
        <input type="submit" value="Buscar">
    </form>

    <!-- Código Java para obtener la lista de ubicaciones y características -->
    <%
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/TripTrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
            statement = connection.createStatement();

            // Procesar la actualización de datos
            if (request.getMethod().equals("POST")) {
                String idUbicacionStr = request.getParameter("idUbicacion");
                String nuevoNombre = request.getParameter("nuevoNombre");
                float nuevaLongitud = Float.parseFloat(request.getParameter("nuevaLongitud"));
                float nuevaLatitud = Float.parseFloat(request.getParameter("nuevaLatitud"));
                String nuevoCostoFig = request.getParameter("nuevoCostoFig");
                String nuevoTiempoFig = request.getParameter("nuevoTiempoFig");
                float nuevaPuntuacion = Float.parseFloat(request.getParameter("nuevaPuntuacion"));
                String nuevaDescripcion = request.getParameter("nuevaDescripcion");

                if (idUbicacionStr != null && nuevoNombre != null && nuevoCostoFig != null && nuevoTiempoFig != null && nuevaDescripcion != null) {
                    int idUbicacion = Integer.parseInt(idUbicacionStr);
                    PreparedStatement updateStatement = connection.prepareStatement("UPDATE ubicacion SET nombreUbicacion=?, longitud=?, latitud=?, costoFig=?, tiempoFig=?, puntuacionProm=?, descripcion=? WHERE idUbicacion=?");
                    updateStatement.setString(1, nuevoNombre);
                    updateStatement.setFloat(2, nuevaLongitud);
                    updateStatement.setFloat(3, nuevaLatitud);
                    updateStatement.setString(4, nuevoCostoFig);
                    updateStatement.setString(5, nuevoTiempoFig);
                    updateStatement.setFloat(6, nuevaPuntuacion);
                    updateStatement.setString(7, nuevaDescripcion);
                    updateStatement.setInt(8, idUbicacion);

                    updateStatement.executeUpdate();
                }
            }

            // Obtener la lista de ubicaciones
            String sqlQuery = "SELECT * FROM ubicacion;";
            String ubicacionBusqueda = request.getParameter("ubicacionBusqueda");
            if (ubicacionBusqueda != null && !ubicacionBusqueda.isEmpty()) {
                sqlQuery = "SELECT * FROM ubicacion WHERE nombreUbicacion LIKE '%" + ubicacionBusqueda + "%';";
            }

            resultSet = statement.executeQuery(sqlQuery);

            List<String[]> ubicaciones = new ArrayList<>();

            while (resultSet.next()) {
                int idUbicacion = resultSet.getInt("idUbicacion");
                String nombreUbicacion = resultSet.getString("nombreUbicacion");
                float longitud = resultSet.getFloat("longitud");
                float latitud = resultSet.getFloat("latitud");
                String costoFig = resultSet.getString("costoFig");
                String tiempoFig = resultSet.getString("tiempoFig");
                float puntuacionProm = resultSet.getFloat("puntuacionProm");
                String descripcion = resultSet.getString("descripcion");
                String[] ubicacionData = {String.valueOf(idUbicacion), nombreUbicacion, String.valueOf(longitud), String.valueOf(latitud), costoFig, tiempoFig, String.valueOf(puntuacionProm), descripcion};
                ubicaciones.add(ubicacionData);
            }
    %>

    <!-- Verificar si hay ubicaciones antes de mostrar la tabla -->
    <% if (!ubicaciones.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>ID Ubicación</th>
                    <th>Nombre Ubicación</th>
                    <th>Longitud</th>
                    <th>Latitud</th>
                    <th>Costo Figura</th>
                    <th>Tiempo Figura</th>
                    <th>Puntuación Promedio</th>
                    <th>Descripción</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Iterar sobre la lista de ubicaciones y mostrar cada fila en la tabla -->
                <% for (String[] ubicacionData : ubicaciones) { %>
                    <tr>
                        <td><%= ubicacionData[0] %></td>
                        <td><%= ubicacionData[1] %></td>
                        <td><%= ubicacionData[2] %></td>
                        <td><%= ubicacionData[3] %></td>
                        <td><%= ubicacionData[4] %></td>
                        <td><%= ubicacionData[5] %></td>
                        <td><%= ubicacionData[6] %></td>
                        <td><%= ubicacionData[7] %></td>
                        <td>
                            <!-- Formulario para editar la ubicación -->
                            <form action="" method="post">
                                <input type="hidden" name="idUbicacion" value="<%= ubicacionData[0] %>">
                                <label for="nuevoNombre">Nombre:</label>
                                <input type="text" name="nuevoNombre" value="<%= ubicacionData[1] %>">
                                <label for="nuevaLongitud">Longitud:</label>
                                <input type="text" name="nuevaLongitud" value="<%= ubicacionData[2] %>">
                                <label for="nuevaLatitud">Latitud:</label>
                                <input type="text" name="nuevaLatitud" value="<%= ubicacionData[3] %>">
                                <label for="nuevoCostoFig">Costo Figura:</label>
                                <input type="text" name="nuevoCostoFig" value="<%= ubicacionData[4] %>">
                                <label for="nuevoTiempoFig">Tiempo Figura:</label>
                                <input type="text" name="nuevoTiempoFig" value="<%= ubicacionData[5] %>">
                                <label for="nuevaPuntuacion">Puntuación Promedio:</label>
                                <input type="text" name="nuevaPuntuacion" value="<%= ubicacionData[6] %>">
                                <label for="nuevaDescripcion">Descripción:</label>
                                <input type="text" name="nuevaDescripcion" value="<%= ubicacionData[7] %>">
                                <input type="submit" value="Actualizar">
                            </form>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p>No hay ubicaciones disponibles.</p>
    <% } %>

    <%-- Cierre de recursos --%>
    <% } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (statement != null) statement.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
</body>
</html>
