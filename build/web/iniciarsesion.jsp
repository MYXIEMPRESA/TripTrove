<%@page import="java.util.Comparator"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <link rel="icon" href="CSS/fotitos/logo.png" type="image/png">
    </head>
    <body>
    </body>
</html>
<%
    String usuarioIngresado = request.getParameter("usuario");
    String contraseniaIngresada = request.getParameter("contrasenia");

    Connection conexion = null;
    Statement statement = null;
    ResultSet resultado = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");
        statement = conexion.createStatement();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3308/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");

        if (resultado.next()) {
            String contraseniaAlmacenada = resultado.getString("contra");
            if (contraseniaIngresada.equals(contraseniaAlmacenada)) {
                // Las contraseñas coinciden
                int idRol = resultado.getInt("idRol");
                if (idRol == 1) { // Supongamos que 1 es el idRol de administrador
                    response.sendRedirect("administrador.html");
                } else if (idRol == 2) {
                    response.sendRedirect("servicioTecnico.html");
                } else if (idRol == 3) {
                    response.sendRedirect("principal.jsp?usuario=" + usuarioIngresado);
                }

              

int n = ubicacionesNombres.size();

for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
        String ubicacionA = ubicacionesNombres.get(j);
        String ubicacionB = ubicacionesNombres.get(j + 1);

        if (ubicacionFrecuencia.get(ubicacionB) > ubicacionFrecuencia.get(ubicacionA)) {
            // Intercambiar ubicacionA y ubicacionB
            String temp = ubicacionA;
            ubicacionesNombres.set(j, ubicacionB);
            ubicacionesNombres.set(j + 1, temp);
        }
    }
}
                // Eliminar duplicados manteniendo el orden
                List<String> ubicacionesNombresUnicas = new ArrayList<>(new LinkedHashSet<>(ubicacionesNombres));

                // Almacena las listas de datos de ubicaciones en la sesión
                HttpSession sesion = request.getSession();
                sesion.setAttribute("ubicacionesNombres", ubicacionesNombresUnicas);
                sesion.setAttribute("ubicacionesCostos", ubicacionesCostos);
                sesion.setAttribute("ubicacionesTiempos", ubicacionesTiempos);
                sesion.setAttribute("ubicacionesPuntuaciones", ubicacionesPuntuaciones);
                sesion.setAttribute("ubicacionesDescripciones", ubicacionesDescripciones);

                // Redirige a la página principal
                response.sendRedirect("principal.html?ubicacionesNombres=" + URLEncoder.encode(String.join(",", ubicacionesNombresUnicas), "UTF-8")
                        + "&ubicacionesCostos=" + URLEncoder.encode(String.join(",", ubicacionesCostos), "UTF-8")
                        + "&ubicacionesTiempos=" + URLEncoder.encode(String.join(",", ubicacionesTiempos), "UTF-8")
                        + "&ubicacionesPuntuaciones=" + URLEncoder.encode(String.join(",", ubicacionesPuntuaciones), "UTF-8")
                        + "&ubicacionesDescripciones=" + URLEncoder.encode(String.join(",", ubicacionesDescripciones), "UTF-8"));
            } else {
                response.sendRedirect("inicio.html");
                }
        } else {
            response.sendRedirect("inicio.html");
        }
    } catch (SQLException | ClassNotFoundException error) {
        out.print(error.toString());
    } finally {
        try {
            if (resultado != null) {
                resultado.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (conexion != null) {
                conexion.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
