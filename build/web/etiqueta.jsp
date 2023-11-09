<%-- 
    Document   : etiqueta
    Created on : 8 nov 2023, 21:23:26
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
    <%  if (request.getParameter("subir") != null) {
    
    response.sendRedirect("principal.html");
    
        }

    %>
</html>
