<%@ page import="connectionDataBase.connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*,java.sql.*"%>
<%
    String usuario = (String) session.getAttribute("usuarioInicio");
    String correo = (String) session.getAttribute("correo");
    String contra = (String) session.getAttribute("contra");
    Connection cnx = null;

    if (request.getParameter("datos") != null) {
        usuario = request.getParameter("usuario");
        correo = request.getParameter("correo");
        contra = request.getParameter("contra");

        connection conx = new connection();
        cnx = conx.connectionAction();

        String checkUserEmailQuery = "SELECT COUNT(*) AS count FROM usuario WHERE usuario = ? OR correo = ?";
        try (PreparedStatement pstCheckUserEmail = cnx.prepareStatement(checkUserEmailQuery)) {
            pstCheckUserEmail.setString(1, usuario);
            pstCheckUserEmail.setString(2, correo);
            ResultSet resultSet = pstCheckUserEmail.executeQuery();

            if (resultSet.next() && resultSet.getInt("count") > 0) {
                response.sendRedirect("../html/registro.html");
            } else {

                session.setAttribute("usuarioInicio", usuario);
                session.setAttribute("correo", correo);
                session.setAttribute("contra", contra);
                response.sendRedirect("../html/etiqueta.html");
            }
        } catch (SQLException e) {
            out.print(e.toString());
        }
    } else if (request.getParameter("subir") != null) {

        String costo = request.getParameter("costo");
        String tiempo = request.getParameter("tiempo");

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
            connection conx = new connection();
            cnx = conx.connectionAction();

            // Insertar en la tabla usuario
            String insertUsuarioQuery = "INSERT INTO usuario (usuario, correo, contra, idRol) VALUES (?, ?, ?, ?)";
            pstUsuario = cnx.prepareStatement(insertUsuarioQuery, Statement.RETURN_GENERATED_KEYS);
            pstUsuario.setString(1, usuario);
            pstUsuario.setString(2, correo);
            pstUsuario.setString(3, contra);
            pstUsuario.setInt(4, 3);
            pstUsuario.executeUpdate();

            int idUsuario = 0;
            try (ResultSet generatedKeys = pstUsuario.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    idUsuario = generatedKeys.getInt(1);
                }
            }

            String insertCaracteristicasQuery = "INSERT INTO caracteristicas (idUsuario, costoFig, tiempoFig) VALUES (?, ?, ?)";
            pstCaracteristicas = cnx.prepareStatement(insertCaracteristicasQuery);
            pstCaracteristicas.setInt(1, idUsuario);
            pstCaracteristicas.setString(2, costo);
            pstCaracteristicas.setString(3, tiempo);
            pstCaracteristicas.executeUpdate();

            int idCaracteristicas = 0;
            String selectIdCaracteristicasQuery = "SELECT LAST_INSERT_ID() AS idCaracteristicas";
            try (Statement stmt = cnx.createStatement(); ResultSet rs = stmt.executeQuery(selectIdCaracteristicasQuery)) {
                if (rs.next()) {
                    idCaracteristicas = rs.getInt("idCaracteristicas");
                }
            }

            String insertCaracterisitcaEspeQuery = "INSERT INTO caracteristicaEsp (idCaracteristicas, tipoCaract) VALUES (?, ?)";
            pstCaracEspeciales = cnx.prepareStatement(insertCaracterisitcaEspeQuery);

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
            session.removeAttribute("usuarioInicio");
            session.removeAttribute("correo");
            session.removeAttribute("contra");
            
            response.sendRedirect("../html/inicio.html");

        } catch (SQLException | NumberFormatException error) {
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
