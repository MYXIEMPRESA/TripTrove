<%-- 
    Document   : cerrarsesion
    Created on : 2 nov 2023, 19:09:53
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
    // Invalidar la sesión actual
    HttpSession sesion = request.getsesion(false);
    if (sesion != null) {
        sesion.invalidate();
    }
    // Redirigir a la página de inicio de sesión o a cualquier otra página deseada
    response.sendRedirect("index.html"); // Cambia "index.html" a la página a la que deseas redirigir al usuario después de cerrar sesión
%>
Este código realiza las siguientes acciones:

Obtiene la sesión actual mediante request.getSession(false). El parámetro false indica que no se creará una nueva sesión si no existe una sesión activa.

Si se encuentra una sesión, la invalida mediante session.invalidate() para cerrar la sesión actual y eliminar las variables de sesión.

Luego, redirige al usuario a la página de inicio de sesión o a cualquier otra página que desees. En el ejemplo, redirige al usuario a "index.html".

Asegúrate de que el enlace "Cerrar sesión" en tu página "principal.jsp" apunte a "logout.jsp" o al nombre que le hayas dado a la página para cerrar sesión.

Este enfoque te permitirá implementar la funcionalidad de cierre de sesión en tu aplicación web Java con variables de sesión. Asegúrate de que las páginas estén configuradas correctamente y que la lógica de autenticación esté en su lugar para garantizar la seguridad de tu aplicación.






    </body>
</html>
