<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.removeAttribute("usuario");
    response.sendRedirect("../index.html");
%>