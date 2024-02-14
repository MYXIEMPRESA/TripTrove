<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="connectionDataBase.connection" %>
<%@page import="objetos.comentario" %>
<%@page import="util.ComentarioDAO" %>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    if (usuario != null) {
        List<String> ubicacionesNombres = new ArrayList<>();
        List<String> ubicacionesCostos = new ArrayList<>();
        List<String> ubicacionesTiempos = new ArrayList<>();
        List<String> ubicacionesDescripciones = new ArrayList<>();
        List<String> ubicacionesNombresUnicas;
        Connection cnx = null;
        CallableStatement sta = null;
        ResultSet rs = null;
        try {
            connection conx = new connection();
            cnx = conx.connectionAction();
            sta = cnx.prepareCall("SELECT u.idUsuario, ce.tipoCaract "
                    + "FROM usuario u "
                    + "JOIN caracteristicas c ON u.idUsuario = c.idUsuario "
                    + "JOIN caracteristicaEsp ce ON c.idCaracteristicas = ce.idCaracteristicas "
                    + "WHERE u.usuario=?");
            sta.setString(1, usuario);
            rs = sta.executeQuery();
            ArrayList<String> tiposCaract = new ArrayList<>();
            while (rs.next()) {
                String tipoCaract = rs.getString("tipoCaract");
                tiposCaract.add(tipoCaract);
            }
            if (!tiposCaract.isEmpty()) {
                // Consulta para obtener las ubicaciones que coinciden con el tipoCaract
                String query = "SELECT u.idUbicacion, u.nombreUbicacion, u.costoFig, u.tiempoFig, u.descripcion "
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
        <link rel="stylesheet" href="../CSS/principal.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.min.js"></script>
    </head>
    <body>
        <header>
            <a href="#" class="logo">TripTrove </a>
            <ul>
                <li><a href="chatUsuario.jsp">CHAT SERVICIO TECNICO</a></li>
                <li><a href="mapa.jsp">MAPA</a></li>
                <li><a href="cerrarSesion.jsp">CERRAR SESION</a></li>

            </ul>
        </header>
        <br><br><br><br>

        <h2 class="titulito">Lugares Populares para ti, <%=usuario%></h2>

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
                        <img src="../CSS/img/principal bosque de chapultepc.jpg" alt="Bosque de Chapultepec">
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
                        <img src="../CSS/img/principal parque la mexicana.jpg" alt="Parque La Mexicana">
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
                        <img src="../CSS/img/principal museo soumaya.jpg" alt="Museo Soumaya">
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
                        <img src="../CSS/img/principal parque bicentenario.jpg" alt="Parque Bicentenario">
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
        <div class="icon-description">
            <i class='bx bxs-star'></i>
            <h2 class="titulito">Recomendados</h2>
        </div>
        <ul id="ubicacionesList">
            <%
                // ...
                for (int i = 0; i < ubicacionesNombresUnicas.size(); i++) {
                    String nombreUbicacion = ubicacionesNombresUnicas.get(i);
                    String costo = ubicacionesCostos.get(i);
                    String tiempo = ubicacionesTiempos.get(i);
                    String descripcion = ubicacionesDescripciones.get(i);
            %>
            <li>
                <!-- Contenido principal -->
                <button class="botoncillo" onclick="mostrarContenido('<%= nombreUbicacion.replace(" ", "")%>')">
                    <strong>Nombre:</strong> <%= nombreUbicacion%><br>
                    <strong>Costo:</strong> <%= costo%><br>
                    <strong>Tiempo:</strong> <%= tiempo%><br>
                    <strong>Descripción:</strong> <%= descripcion%><br><br>
                    <img src='../CSS/recomendaciones/<%= nombreUbicacion.toLowerCase().replace(" ", "")%>.jpg' alt='<%= nombreUbicacion%> Image'>
                </button>
            </li>
            <% }%>
        </ul>
        <div id="contenedorPopup" style="display: none;">
            <div id="ubicacionesContent">            
            </div>
            <script>
                $(document).ready(function () {
                    var pagina = 1; // Página inicial
                    var cargandoComentarios = false; // Bandera para evitar múltiples solicitudes simultáneas

                    // Función para cargar más comentarios con tiempo de espera
                    function cargarComentarios() {
                        // Evitar solicitudes múltiples simultáneas
                        if (cargandoComentarios) {
                            return;
                        }
                        cargandoComentarios = true;

                        $.ajax({
                            url: 'http://localhost:8080/TripTrove/LoadCommentsServlet?pagina=' + pagina + '&limit=5',
                            type: 'GET',
                            success: function (nuevosComentarios) {
                                // Agrega los nuevos comentarios al contenedor
                                $('#comentarios-container').append(nuevosComentarios);
                                pagina++; // Incrementa el número de página

                                // Agrega un tiempo de espera de 1 segundo (1000 milisegundos) antes de permitir la siguiente carga
                                setTimeout(function () {
                                    cargandoComentarios = false;
                                }, 1000);
                            },
                            error: function (error) {
                                console.error('Error al cargar comentarios: ' + error);
                                cargandoComentarios = false; // Asegúrate de restablecer la bandera en caso de error
                            }
                        });
                    }

                    // Detecta el scroll y carga más comentarios cuando el usuario llega al final de la página
                    $('#contenedorPopup').scroll(function () {
                        if ($('#contenedorPopup').scrollTop() + $('#contenedorPopup').height() >= $('#comentarios-container').height() - 150) {
                            cargarComentarios();
                        }
                    });
                });

                // Función para cerrar el cuadro modal
                function cerrarModal() {
                    var contenedor = document.getElementById("contenedorPopup");
                    contenedor.style.display = "none";
                }

                // Mover el siguiente código fuera del bloque $(document).ready
                function mostrarContenido(nombreUbicacion) {
                    // Obtener el contenedor
                    var contenedor = document.getElementById("contenedorPopup");

                    // Añadir automáticamente "comentario.jsp" al array
                    var jspFileNames = [nombreUbicacion.replace(" ", "") + '.jsp', 'comentar.jsp', 'comentarios.jsp']; // Agregar 'comentario.jsp'

                    // Crear un array para almacenar las promesas de las solicitudes fetch
                    var promesas = [];

                    // Función para hacer la solicitud fetch y devolver la promesa
                    function fetchJSP(fileName) {
                        return fetch("ubicaciones/" + fileName).then(response => response.text());
                    }

                    // Iterar sobre los nombres de archivos y crear las promesas
                    for (var i = 0; i < jspFileNames.length; i++) {
                        promesas.push(fetchJSP(jspFileNames[i]));
                    }
                    // Usar Promise.all para esperar a que todas las promesas se resuelvan
                    Promise.all(promesas).then(responses => {
                        // Mostrar el contenido en el contenedor
                        contenedor.innerHTML = responses.join("<br>");
                        // Mostrar el contenedor
                        contenedor.style.display = "block";
                    }).catch(error => console.error("Error al cargar archivos JSP:", error));
                }
            </script>
            <%
                        }
                    } catch (SQLException error) {
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
                } else {
                    response.sendRedirect("../index.html");
                }
            %>
    </body>
</html>