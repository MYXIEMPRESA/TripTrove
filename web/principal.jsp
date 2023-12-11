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
%><%=idUsuario%><%
    List<String> ubicacionesNombres = new ArrayList<>();
    List<String> ubicacionesCostos = new ArrayList<>();
    List<String> ubicacionesTiempos = new ArrayList<>();
    List<String> ubicacionesPuntuaciones = new ArrayList<>();
    List<String> ubicacionesDescripciones = new ArrayList<>();
    List<String> ubicacionesNombresUnicas;
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
                + "WHERE u.usuario=?");
        sta.setString(1, idUsuario);
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
            ubicacionesNombresUnicas = new ArrayList<>(new LinkedHashSet<>(ubicacionesNombres));
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <title>Principal - TripTrove</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Página Principal</title>
        <link rel="stylesheet" href="CSS/principal.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
        <!-- Enlace a Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js"></script>
        <style>
            #ubicacionesList {
                list-style: none;
                padding: 0;
                display: flex;
                flex-wrap: wrap;
                justify-content: space-around;
            }
            button {
                border: 1px solid #ddd;
                margin: 10px;
                padding: 15px;
                border-radius: 8px;
                background-color: #f9f9f9;
                flex: 0 1 calc(30% - 20px);
                box-sizing: border-box;
                cursor: pointer;
                transition: background-color 0.3s;
                text-align: left;
            }
            button:hover {
                background-color: #e0e0e0;
            }
            button img {
                max-width: 300px;
                max-height: 300px;
                height: auto;
                border-radius: 8px;
                margin-top: 10px;
                display: block;
                margin: 0 auto;
            }
        </style>
    </head>
    <body>
        <header>
            <a href="#" class="logo">TripTrove </a>
            <input type="text" placeholder="¿A dónde vamos?" class="search-input">
            <ul>
                <li><a href="jsp/cerrarsesion.jsp">CERRAR SESION</a></li>
                <li><a href="mapa.jsp"><button class="location-button"><span class="material-symbols-outlined">location_on</span></button></a></li>
                <li><a href="chatUsuario.jsp"><button class="user-button"><span class="material-symbols-outlined">person</span></button></a></li>
            </ul>
        </header>
        <h2 class="titulito">LUGARES POPULARES</h2>
        <div class="cajita">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <!-- Indicadores de navegación -->
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                    <li data-target="#myCarousel" data-slide-to="3"></li>
                </ol>
                <!-- Imágenes del carrusel -->
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="CSS/img/principal bosque de chapultepc.jpg" alt="Bosque de Chapultepec">
                        <div class="textito">
                            <h2> BOSQUE DE CHAPULTEPEC</h2>
                            <p>
                                El bosque de Chapultepec es uno de los lugares más emblemáticos de la Ciudad de México. Es un gran parque urbano con una superficie de más de 686 hectáreas, que alberga una gran variedad de flora y fauna.
                            </p>
                            <!-- Descripción del lugar -->
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="CSS/img/principal parque la mexicana.jpg" alt="Parque La Mexicana">
                        <div class="textito">
                            <h2> PARQUE LA MEXICANA</h2>
                            <p>
                                El parque La Mexicana es un parque urbano ubicado en la delegación Miguel Hidalgo. Es un espacio de recreación y convivencia para los habitantes de la Ciudad de México.
                            </p>
                            <!-- Descripción del lugar -->
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="CSS/img/principal museo soumaya.jpg" alt="Museo Soumaya">
                        <div class="textito">
                            <h2> MUSEO SOUMAYA</h2>
                            <p>
                                El museo Soumaya es un museo de arte ubicado en la Ciudad de México. Alberga una colección de arte mexicano e internacional, que incluye obras de artistas como Miguel Ángel, Leonardo da Vinci, Picasso y Diego Rivera.
                            </p>
                            <!-- Descripción del lugar -->
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="CSS/img/principal parque bicentenario.jpg" alt="Parque Bicentenario">
                        <div class="textito">
                            <h2> PARQUE BICENTENARIO</h2>
                            <p>
                                El parque Bicentenario es un parque urbano ubicado en la delegación Iztacalco. Fue construido con motivo del bicentenario de la Independencia de México y es un espacio de recreación y cultura para los habitantes de la Ciudad de México.
                            </p>
                            <!-- Descripción del lugar -->
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <i class="far fa-star"></i>
                                <i class="far fa-star"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Controles de navegación -->
                <a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="sr-only">Anterior</span>
                </a>
                <a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
                    <span class="carousel-control-next-icon" ariahidden="true"></span>
                    <span class="sr-only">Siguiente</span>
                </a>
            </div>
        </div>
        <div class="container text-center">
            <button class="btn btn-primary mt-3" onclick="window.location.href = 'index.html'">Regresar al Menú Principal</button>
        </div>
        <div class="desliza">
            <div class="scroll imgbx" style="--t:25s">
                <div>
                    <img src="CSS/img/principal l.jpg">
                    <img src="CSS/img/principal 2.jpg">
                    <img src="CSS/img/principal 3.jpg">
                    <img src="CSS/img/principal 4.jpg">
                    <img src="CSS/img/principal 5.jpg">
                    <img src="CSS/img/principal 6.jpg">
                    <img src="CSS/img/principal 7.jpg">
                    <img src="CSS/img/principal 8.jpg">
                    <img src="CSS/img/principal 9.jpg">
                </div>
                <div>
                    <img src="CSS/img/principal l.jpg">
                    <img src="CSS/img/principal 2.jpg">
                    <img src="CSS/img/principal 3.jpg">
                    <img src="CSS/img/principal 4.jpg">
                    <img src="CSS/img/principal 5.jpg">
                    <img src="CSS/img/principal 6.jpg">
                    <img src="CSS/img/principal 7.jpg">
                    <img src="CSS/img/principal 8.jpg">
                    <img src="CSS/img/principal 9.jpg">
                </div>
            </div>
        </div>
        <h1>Ubicaciones Recomendadas:</h1>
        <ul id="ubicacionesList">
            <%                // Lógica para obtener y mostrar recomendaciones aquí
                // ...
                for (int i = 0; i < ubicacionesNombresUnicas.size(); i++) {
                    String nombreUbicacion = ubicacionesNombresUnicas.get(i);
                    String costo = ubicacionesCostos.get(i);
                    String tiempo = ubicacionesTiempos.get(i);
                    String puntuacion = ubicacionesPuntuaciones.get(i);
                    String descripcion = ubicacionesDescripciones.get(i);
            %>
            <li>
                <button onclick="window.location.href = 'ubicaciones/<%= nombreUbicacion%>.html'">
                    <strong>Nombre:</strong> <%= nombreUbicacion%><br>
                    <strong>Costo:</strong> <%= costo%><br>
                    <strong>Tiempo:</strong> <%= tiempo%><br>
                    <strong>Puntuación Promedio:</strong> <%= puntuacion%><br>
                    <strong>Descripción:</strong> <%= descripcion%><br><br>
                    <img src='CSS/recomendaciones/<%= nombreUbicacion.toLowerCase().replace(" ", "")%>.jpg' alt='<%= nombreUbicacion%> Image'>
                </button>
            </li>
            <% }%>
        </ul>
        <%
                }
            } catch (SQLException | ClassNotFoundException error) {
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

        %>
        <div id="noRecomendaciones" style="text-align: center; margin-top: 20px; font-size: 18px;">
            <img src="CSS/recomendaciones/caratriste.png" alt="Cara Triste" style="width: 50px;">
            <p>¡Oh no! Ya no tenemos más recomendaciones para ti.</p>
        </div>
    </body>
</html>
