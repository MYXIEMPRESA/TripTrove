<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="connectionDataBase.connection"%>
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

    <form action="" method="get">
        <label for="ubicacionBusqueda">Buscar Ubicación:</label>
        <input type="text" id="ubicacionBusqueda" name="ubicacionBusqueda">
        <input type="submit" value="Buscar">
    </form>


    <%
        Connection cnx = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            connection connection = new connection();
            cnx = connection.connectionAction();
            statement = cnx.createStatement();

            // Procesar la actualización de datos
            if (request.getMethod().equals("POST")) {
                String idUbicacionStr = request.getParameter("idUbicacion");
                String nuevoNombre = request.getParameter("nuevoNombre");
                float nuevaLongitud = Float.parseFloat(request.getParameter("nuevaLongitud"));
                float nuevaLatitud = Float.parseFloat(request.getParameter("nuevaLatitud"));
                String nuevoCostoFig = request.getParameter("nuevoCostoFig");
                String nuevoTiempoFig = request.getParameter("nuevoTiempoFig");
                String nuevaDescripcion = request.getParameter("nuevaDescripcion");

                if (idUbicacionStr != null && nuevoNombre != null && nuevoCostoFig != null && nuevoTiempoFig != null && nuevaDescripcion != null) {
                    int idUbicacion = Integer.parseInt(idUbicacionStr);
                    PreparedStatement updateStatement = cnx.prepareStatement("UPDATE ubicacion SET nombreUbicacion=?, longitud=?, latitud=?, costoFig=?, tiempoFig=?, descripcion=? WHERE idUbicacion=?");
                    updateStatement.setString(1, nuevoNombre);
                    updateStatement.setFloat(2, nuevaLongitud);
                    updateStatement.setFloat(3, nuevaLatitud);
                    updateStatement.setString(4, nuevoCostoFig);
                    updateStatement.setString(5, nuevoTiempoFig);
                    updateStatement.setString(6, nuevaDescripcion);
                    updateStatement.setInt(7, idUbicacion);

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
                String descripcion = resultSet.getString("descripcion");
                String[] ubicacionData = {String.valueOf(idUbicacion), nombreUbicacion, String.valueOf(longitud), String.valueOf(latitud), costoFig, tiempoFig, descripcion};
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
                                <input type="text" name="nuevaPuntuacion" value="<%= ubicacionData[5] %>">
                                <label for="nuevaDescripcion">Descripción:</label>
                                <input type="text" name="nuevaDescripcion" value="<%= ubicacionData[6] %>">
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
            if (cnx != null) cnx.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    %>
</body>
</html>
