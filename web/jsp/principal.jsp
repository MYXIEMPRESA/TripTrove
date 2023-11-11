<%-- 
    Document   : pprincipal
    Created on : 2 nov 2023, 18:33:03
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
        <%
       HttpSession sesion = request.getSession();
                            String tipoUsuario = "gerente";
                            sesion.setAttribute("loggedIn", true);
                            sesion.setAttribute("usuario", usuario);
                            sesion.setAttribute("Tipousuario", tipoUsuario);
                            %>
    </body>
</html>
