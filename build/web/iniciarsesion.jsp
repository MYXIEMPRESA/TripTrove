<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.ArrayList" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
     <%
        String idUsuario = request.getParameter("usuario");
        String contra = request.getParameter("contra");

        Connection cnx = null;
        CallableStatement sta = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
            
            // Modificamos la consulta para obtener el tipoCaract
            sta = cnx.prepareCall("SELECT u.idUsuario, ce.tipoCaract " +
                                  "FROM usuario u " +
                                  "JOIN caracteristicas c ON u.idUsuario = c.idUsuario " +
                                  "JOIN caracterisitcaEspe ce ON c.idCaracteristicas = ce.idCaracteristicas " +
                                  "WHERE u.usuario=? AND u.contra=?");
            sta.setString(1, idUsuario);
            sta.setString(2, contra);

            rs = sta.executeQuery();

            ArrayList<String> tiposCaract = new ArrayList<>();

            while (rs.next()) {
                String tipoCaract = rs.getString("tipoCaract");
                tiposCaract.add(tipoCaract);
            }
            String tiposCaractParam = URLEncoder.encode(String.join(",", tiposCaract), "UTF-8");

            if (!tiposCaract.isEmpty()) {
                HttpSession sesion = request.getSession();
                sesion.setAttribute("loggedIn", true);
                sesion.setAttribute("idUsuario", idUsuario);

                response.sendRedirect("principal.html?tiposCaract=" + tiposCaractParam);
            } else {
                response.sendRedirect("index.html"); // Redirigir si la autenticación falla
            }
        } catch (SQLException | ClassNotFoundException error) {
            out.print(error.toString());
        }
     %>     
    </body>
</html>
