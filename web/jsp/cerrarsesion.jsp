<%-- 
    Document   : cerrarsesion
    Created on : 2 nov 2023, 19:09:53
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
       <%
    // Invalidar la sesión actual
    if (session != null) {
        session.invalidate();
        response.sendRedirect("../prueba.html");
    }

    // Redirigir a la página de inicio de sesión
    response.sendRedirect("../index.html");
      %>
    </body>
</html>
