<%-- 
    Document   : etiqueta
    Created on : 8 nov 2023, 21:23:26
    Author     : danim
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>

<%

    
    // Obtener valores de la sesión si ya existen
    String usuarioo = (String)session.getAttribute("usuario");
    String correo = (String)session.getAttribute("correo");
    String contra = (String)session.getAttribute("contra");

    if(request.getParameter("datos") != null){
        usuarioo = request.getParameter("usuario");
        correo = request.getParameter("correo");
        contra = request.getParameter("contra");

        // Almacenar valores en la sesión
        session.setAttribute("usuario", usuarioo);
        session.setAttribute("correo", correo);
        session.setAttribute("contra", contra);

        request.getRequestDispatcher("etiqueta.html").forward(request, response);
    }
    else if (request.getParameter("subir") != null) {
        
             // Obtener valores de los checkboxes
        String diversion = request.getParameter("diversion");
        String cultural = request.getParameter("cultural");
        String familiar = request.getParameter("familiar");
        String naturaleza = request.getParameter("naturaleza");
        String museos = request.getParameter("museos");
        String parques = request.getParameter("parques");

       // Obtener valores de los selects
        String costo = request.getParameter("costo");
        String tiempo = request.getParameter("tiempo");
    
        Connection cnx = null;
        PreparedStatement pst = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
            String insertQuery = "INSERT INTO usuario (usuario, correo, contra) VALUES (?, ?, ?)";
            pst = cnx.prepareStatement(insertQuery);
            pst.setString(1, usuarioo);
            pst.setString(2, correo);
            pst.setString(3, contra);
            pst.executeUpdate();
            
            // Redirigir después de la inserción
            response.sendRedirect("inicio.html");

        } catch (SQLException | ClassNotFoundException error) {
            out.print(error.toString());
        }
    }
%>
</html>
