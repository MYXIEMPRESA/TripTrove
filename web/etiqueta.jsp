<%-- 
    Document   : etiqueta
    Created on : 8 nov 2023, 21:23:26
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>

    <%

        // Obtener valores de la sesión si ya existen
        String usuario = (String) session.getAttribute("usuario");
        String correo = (String) session.getAttribute("correo");
        String contra = (String) session.getAttribute("contra");
        Connection cnx = null;

        if (request.getParameter("datos") != null) {
            usuario = request.getParameter("usuario");
            correo = request.getParameter("correo");
            contra = request.getParameter("contra");

            

            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3308/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");

            String checkUserEmailQuery = "SELECT COUNT(*) AS count FROM usuario WHERE usuario = ? OR correo = ?";
            try (PreparedStatement pstCheckUserEmail = cnx.prepareStatement(checkUserEmailQuery)) {
                pstCheckUserEmail.setString(1, usuario);
                pstCheckUserEmail.setString(2, correo);
                ResultSet resultSet = pstCheckUserEmail.executeQuery();
                if (resultSet.next() && resultSet.getInt("count") > 0) {
                    // User or email already exists, handle it (e.g., display an error message)
                    response.sendRedirect("registro.html");
                } else {
                    // Almacenar valores en la sesión
                    session.setAttribute("usuario", usuario);
                    session.setAttribute("correo", correo);
                    session.setAttribute("contra", contra);
                    response.sendRedirect("etiqueta.html");
                }
            } catch (SQLException e) {
                out.print(e.toString());
            }
        } else if (request.getParameter("subir") != null) {

            // Obtener valores de los selects
            String costo = request.getParameter("costo");
            String tiempo = request.getParameter("tiempo");

            // Obtener valores de los checkboxes
            // Obtener valores de los parámetros
            String diversion = request.getParameter("diversion");
            String cultural = request.getParameter("cultural");
            String familiar = request.getParameter("familiar");
            String naturaleza = request.getParameter("naturaleza");
            String museos = request.getParameter("museos");
            String parques = request.getParameter("parques");

            PreparedStatement pstUsuario = null;
            PreparedStatement pstCaracteristicas = null;
            PreparedStatement pstCaracEspeciales = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                cnx = DriverManager.getConnection("jdbc:mysql://localhost:3308/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");

                // Insertar en la tabla usuario
                String insertUsuarioQuery = "INSERT INTO usuario (usuario, correo, contra, idRol) VALUES (?, ?, ?, ?)";
                pstUsuario = cnx.prepareStatement(insertUsuarioQuery, Statement.RETURN_GENERATED_KEYS);
                pstUsuario.setString(1, usuario);
                pstUsuario.setString(2, correo);
                pstUsuario.setString(3, contra);
                pstUsuario.setInt(4, 3); // 3 es el número de idRol que deseas asignar
                pstUsuario.executeUpdate();

                // Obtener el ID del usuario recién insertado
                int idUsuario = 0;
                try (ResultSet generatedKeys = pstUsuario.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        idUsuario = generatedKeys.getInt(1);
                    }
                }

                // Insertar en la tabla caracteristicas
                String insertCaracteristicasQuery = "INSERT INTO caracteristicas (idUsuario, costoFig, tiempoFig) VALUES (?, ?, ?)";
                pstCaracteristicas = cnx.prepareStatement(insertCaracteristicasQuery);
                pstCaracteristicas.setInt(1, idUsuario);
                pstCaracteristicas.setString(2, costo);
                pstCaracteristicas.setString(3, tiempo);
                pstCaracteristicas.executeUpdate();

                // Obtener el ID de caracteristicas recién insertado
                int idCaracteristicas = 0;
                String selectIdCaracteristicasQuery = "SELECT LAST_INSERT_ID() AS idCaracteristicas";
                try (Statement stmt = cnx.createStatement(); ResultSet rs = stmt.executeQuery(selectIdCaracteristicasQuery)) {
                    if (rs.next()) {
                        idCaracteristicas = rs.getInt("idCaracteristicas");
                    }
                }

                // Insertar en la tabla caracterisitcaEspe solo los checkboxes seleccionados
                String insertCaracterisitcaEspeQuery = "INSERT INTO caracteristicaEsp (idCaracteristicas, tipoCaract) VALUES (?, ?)";
                pstCaracEspeciales = cnx.prepareStatement(insertCaracterisitcaEspeQuery);

                // Insertar para cada tipo de característica especial solo si está seleccionada
                if (diversion != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "diversion");
                    pstCaracEspeciales.executeUpdate();
                }

                if (cultural != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "cultural");
                    pstCaracEspeciales.executeUpdate();
                }

                if (familiar != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "familiar");
                    pstCaracEspeciales.executeUpdate();
                }

                if (naturaleza != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "naturaleza");
                    pstCaracEspeciales.executeUpdate();
                }

                if (museos != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "museos");
                    pstCaracEspeciales.executeUpdate();
                }

                if (parques != null) {
                    pstCaracEspeciales.setInt(1, idCaracteristicas);
                    pstCaracEspeciales.setString(2, "parques");
                    pstCaracEspeciales.executeUpdate();
                }

                // Redirigir después de la inserción
                response.sendRedirect("inicio.html");

            } catch (SQLException | ClassNotFoundException | NumberFormatException error) {
                out.print(error.toString());
            } finally {
                try {
                    if (pstUsuario != null) {
                        pstUsuario.close();
                    }
                    if (pstCaracteristicas != null) {
                        pstCaracteristicas.close();
                    }
                    if (pstCaracEspeciales != null) {
                        pstCaracEspeciales.close();
                    }
                    if (cnx != null) {
                        cnx.close();
                    }
                } catch (SQLException e) {
                    out.print(e.toString());
                }
            }

        }
    %>
</html>
