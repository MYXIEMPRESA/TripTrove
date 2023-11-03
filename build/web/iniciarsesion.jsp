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
                cnx = DriverManager.getConnection("jdbc:mysql://localhost:3308/tritrop?autoReconnect=true&useSSL=false", "root", "n0m3l0");
                sta = cnx.prepareCall("select usuario, contra from usuario where usuario='" + usuario + "' and contra='" + contra + "'");
                
                rs = sta.executeQuery();
                if (rs.next()) {
                                        request.getRequestDispatcher("principal.html").forward(request, response);

                    
                }
                else if(!rs.next()){
           
                                                   request.getRequestDispatcher("index.html").forward(request, response);

           }
                
            } catch (SQLException error) {
                out.print(error.toString());
            }
        %>
    </body>
</html>
