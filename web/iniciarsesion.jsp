<%-- 
    Document   : iniciarsesion
    Created on : 2 nov 2023, 18:09:04
    Author     : danim
--%>
<%@page import="java.sql.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
     <%
    String usuario = request.getParameter("usuario");
    String contra = request.getParameter("contra");

    Connection cnx = null;
    CallableStatement sta = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
        sta = cnx.prepareCall("select usuario, contra from usuario where usuario=? and contra=?");
        sta.setString(1, usuario);
        sta.setString(2, contra);

        rs = sta.executeQuery();

        if (rs.next()) {
            HttpSession sesion = request.getSession();
            sesion.setAttribute("loggedIn", true);
            sesion.setAttribute("usuario", usuario);
            // Verificar si el usuario ha iniciado sesión
            Boolean loggedIn = (Boolean) sesion.getAttribute("loggedIn");
            // Si el usuario no ha iniciado sesión, redirigir a la página de inicio de sesión
            if (usuario == null || !loggedIn) {
                response.sendRedirect("../index.html");
            } else {
                response.sendRedirect("../principal.html");
            }
        } else {
            response.sendRedirect("../index.html"); // Redirigir si la autenticación falla
        }
    } catch (SQLException error) {
        out.print(error.toString());
    }
%>

             
    </body>
</html>
