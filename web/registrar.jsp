<%-- 
    Document   : registrar
    Created on : 2 nov 2023, 16:11:47
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
            if (request.getParameter("subir") != null) {

                String usuarioo = request.getParameter("usuario");
                String correo = request.getParameter("correo");
                String contra = request.getParameter("contra");

                Connection cnx = null;
                PreparedStatement pst = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    cnx = DriverManager.getConnection("jdbc:mysql://localhost:3308/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
                    String insertQuery = "INSERT INTO usuario (usuario, correo, contra) VALUES (?, ?, ?)";
                    pst = cnx.prepareStatement(insertQuery);
                    pst.setString(1, usuarioo);
                    pst.setString(2, correo);
                    pst.setString(3, contra);
                    pst.executeUpdate();
                    request.getRequestDispatcher("etiqueta.html").forward(request, response);
                } catch (SQLException error) {
                    out.print(error.toString());
                }
            }%>
    </body>
</html>
