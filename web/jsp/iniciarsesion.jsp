<%@ page import="connectionDataBase.connection"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String usuarioIngresado = request.getParameter("usuario");
    String contraseniaIngresada = request.getParameter("contrasenia");

    Connection cnx = null;
    Statement statement = null;
    ResultSet resultado = null;

    try {
        connection conx = new connection();
        cnx = conx.connectionAction();
        statement = cnx.createStatement();

        // Consulta para obtener la contraseña y el idRol del usuario ingresado
        String sql = "SELECT contra , idRol, idUsuario FROM usuario WHERE usuario = '" + usuarioIngresado + "' AND contra = '" + contraseniaIngresada + "'";
        resultado = statement.executeQuery(sql);

        if (resultado.next()) {
            String contraseniaAlmacenada = resultado.getString("contra");
            if (contraseniaIngresada.equals(contraseniaAlmacenada)) {
                int idRol = resultado.getInt("idRol");
                int idUsuario = resultado.getInt("idUsuario");
                if (idRol == 1) {
                    session.setAttribute("usuario", usuarioIngresado);
                    session.setAttribute("idUsuario", idUsuario);
                    response.sendRedirect("../html/administrador.html");
                } else if (idRol == 2) {
                    session.setAttribute("usuario", usuarioIngresado);
                    session.setAttribute("idUsuario", idUsuario);
                    response.sendRedirect("../html/servicioTecnico.html");
                } else if (idRol == 3) {
                    session.setAttribute("usuario", usuarioIngresado);
                    session.setAttribute("idUsuario", idUsuario);
                    response.sendRedirect("principal.jsp");
                }
            } else {
                // Contraseña incorrecta, establecer atributo de error
                request.setAttribute("error", "Contraseña incorrecta");
                response.sendRedirect("../html/inicio.html");
            }
        } else {
            // Usuario no encontrado, establecer atributo de error
            request.setAttribute("error", "Usuario no encontrado");
            response.sendRedirect("../html/inicio.html");
        }
    } catch (SQLException error) {
        out.print(error.toString());
    } finally {
        try {
            if (resultado != null) {
                resultado.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (cnx != null) {
                cnx.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
