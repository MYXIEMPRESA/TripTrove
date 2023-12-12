<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String usuarioIngresado = request.getParameter("usuario");
    String contraseniaIngresada = request.getParameter("contrasenia");

    Connection conexion = null;
    Statement statement = null;
    ResultSet resultado = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "1234");
        statement = conexion.createStatement();

        // Consulta para obtener la contraseña y el idRol del usuario ingresado
        String sql = "SELECT contra, idRol FROM usuario WHERE usuario = '" + usuarioIngresado + "'";
        resultado = statement.executeQuery(sql);

        if (resultado.next()) {
            String contraseniaAlmacenada = resultado.getString("contra");
            if (contraseniaIngresada.equals(contraseniaAlmacenada)) {
                // Las contraseñas coinciden
                int idRol = resultado.getInt("idRol");
                session.setAttribute("usuario", usuarioIngresado);

                if (idRol == 1) { // Supongamos que 1 es el idRol de administrador
                    response.sendRedirect("administrador.html");
                } else if (idRol == 2) {
                    response.sendRedirect("servicioTecnico.html");
                } else if (idRol == 3) {
                    response.sendRedirect("principal.jsp?usuario=" + usuarioIngresado);
                }
            } else {
                // Contraseña incorrecta, establecer atributo de error
                request.setAttribute("error", "Contraseña incorrecta");
                response.sendRedirect("inicio.html");
            }
        } else {
            // Usuario no encontrado, establecer atributo de error
            request.setAttribute("error", "Usuario no encontrado");
            response.sendRedirect("inicio.html");
        }
    } catch (SQLException | ClassNotFoundException error) {
        out.print(error.toString());
    } finally {
        try {
            if (resultado != null) {
                resultado.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (conexion != null) {
                conexion.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
