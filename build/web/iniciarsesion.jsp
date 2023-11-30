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
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idUsuario = request.getParameter("usuario");
    String contra = request.getParameter("contra");

    if ("administrador".equals(idUsuario)) {
        response.sendRedirect("administrador.html");
    } else {

        Connection cnx = null;
        CallableStatement sta = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cnx = DriverManager.getConnection("jdbc:mysql://localhost:3306/triptrove?autoReconnect=true&useSSL=false", "root", "n0m3l0");

            // Modificamos la consulta para obtener el tipoCaract
            sta = cnx.prepareCall("SELECT u.idUsuario, ce.tipoCaract "
                    + "FROM usuario u "
                    + "JOIN caracteristicas c ON u.idUsuario = c.idUsuario "
                    + "JOIN caracteristicaEsp ce ON c.idCaracteristicas = ce.idCaracteristicas "
                    + "WHERE u.usuario=? AND u.contra=?");
            sta.setString(1, idUsuario);
            sta.setString(2, contra);

            rs = sta.executeQuery();

            ArrayList<String> tiposCaract = new ArrayList<>();

            while (rs.next()) {
                String tipoCaract = rs.getString("tipoCaract");
                tiposCaract.add(tipoCaract);
            }

            if (!tiposCaract.isEmpty()) {
                // Consulta para obtener las ubicaciones que coinciden con el tipoCaract
                String query = "SELECT u.idUbicacion, u.nombreUbicacion, u.costoFig, u.tiempoFig, u.puntuacionProm, u.descripcion "
                        + "FROM ubicacion u "
                        + "JOIN caracteristicaEspeUbicaciones ceu ON u.idUbicacion = ceu.idUbicacion "
                        + "WHERE ceu.tipoCaract IN (?)";
                String tiposCaractParam = "'" + String.join("','", tiposCaract) + "'";
                query = query.replace("?", tiposCaractParam);

                sta = cnx.prepareCall(query);
                rs = sta.executeQuery();

                // Mapa para contar la frecuencia de cada ubicación
                Map<String, Integer> ubicacionFrecuencia = new HashMap<>();

                // Listas para almacenar los datos de ubicaciones
                List<String> ubicacionesNombres = new ArrayList<>();
                List<String> ubicacionesCostos = new ArrayList<>();
                List<String> ubicacionesTiempos = new ArrayList<>();
                List<String> ubicacionesPuntuaciones = new ArrayList<>();
                List<String> ubicacionesDescripciones = new ArrayList<>();

                while (rs.next()) {
                    String nombreUbicacion = rs.getString("nombreUbicacion");

                    // Incrementa la frecuencia de la ubicación
                    ubicacionFrecuencia.put(nombreUbicacion, ubicacionFrecuencia.getOrDefault(nombreUbicacion, 0) + 1);

                    // Agrega los datos de ubicación a las listas
                    ubicacionesNombres.add(rs.getString("nombreUbicacion"));
                    ubicacionesCostos.add(rs.getString("costoFig"));
                    ubicacionesTiempos.add(rs.getString("tiempoFig"));
                    ubicacionesPuntuaciones.add(rs.getString("puntuacionProm"));
                    ubicacionesDescripciones.add(rs.getString("descripcion"));
                }

                for (int i = 0; i < ubicacionesNombres.size() - 1; i++) {
                    for (int j = i + 1; j < ubicacionesNombres.size(); j++) {
                        String ubicacionI = ubicacionesNombres.get(i);
                        String ubicacionJ = ubicacionesNombres.get(j);

                        if (ubicacionFrecuencia.get(ubicacionJ) > ubicacionFrecuencia.get(ubicacionI)) {
                            // Intercambia las ubicaciones
                            String temp = ubicacionI;
                            ubicacionesNombres.set(i, ubicacionJ);
                            ubicacionesNombres.set(j, temp);
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
                response.sendRedirect("index.html"); // Redirigir si la autenticación falla
            }
        } catch (SQLException | ClassNotFoundException | UnsupportedEncodingException error) {
            out.print(error.toString());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (sta != null) {
                    sta.close();
                }
                if (cnx != null) {
                    cnx.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
