<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mi Mapa</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                display: flex;
            }

            #map {
                flex: 1;
                height: 100vh;
            }

            #ruta-info {
                flex: 0.5;
                height: 100vh;
                overflow-y: auto;
                padding: 10px;
                box-sizing: border-box;
            }

            #contenedor-botones {
                clear: both;
                padding-top: 10px;
            }
        </style>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDXhXtV1rMD-5y15llNS1fFMl8u8TvVBoo&callback=initMap" async defer></script>
    </head>
    <body>

        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Conectar a la base de datos
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/TripTrove";
                String user = "root";
                String password = "n0m3l0";
                conn = DriverManager.getConnection(url, user, password);

                // Consultar ubicaciones desde la base de datos
                List<Map<String, Object>> ubicaciones = new ArrayList<>();
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM ubicacion");

                while (rs.next()) {
                    Map<String, Object> ubicacion = new HashMap<>();
                    ubicacion.put("nombre", rs.getString("nombreUbicacion"));
                    ubicacion.put("latitud", rs.getDouble("latitud"));
                    ubicacion.put("longitud", rs.getDouble("longitud"));
                    // Agregar más atributos según sea necesario
                    ubicaciones.add(ubicacion);
                }
        %>


        <div>
            <label for="modoViaje">Elegir modo de viaje:</label>
            <select id="modoViaje">
                <option value="WALKING">Caminando</option>
                <option value="DRIVING">Manejando</option>
            </select>
            <button onclick="iniciarRuta()">Iniciar Ruta</button>
        </div>

        <div id="map"></div>
        <div id="ruta-info"></div>

        <div id="contenedor-botones">
            <button onclick="elegirNuevaRuta()">Elegir Nueva Ruta</button>
        </div>

        <script>
            var ubicacionesJSON = <%= new Gson().toJson(ubicaciones)%>;

            // Utilizar la variable ubicacionesJSON en lugar de la variable ubicaciones
            var lugares = ubicacionesJSON;
            var directionsService, directionsRenderer;
            var puntosRuta = [];

            function initMap() {
                var map = new google.maps.Map(document.getElementById('map'), {
                    center: {lat: 19.4326, lng: -99.1332},
                    zoom: 12
                });

                directionsService = new google.maps.DirectionsService();
                directionsRenderer = new google.maps.DirectionsRenderer({suppressMarkers: true, panel: document.getElementById('ruta-info')});
                directionsRenderer.setMap(map);

                lugares.forEach(function (lugar, index) {
                    var marker = new google.maps.Marker({
                        position: {lat: lugar.latitud, lng: lugar.longitud},
                        map: map,
                        title: lugar.nombre
                    });

                    var infowindow = new google.maps.InfoWindow({
                        content: lugar.nombre
                    });

                    marker.addListener('click', function () {
                        infowindow.open(map, marker);
                        document.getElementById('ruta-info').innerHTML = '';
                        puntosRuta.push({lat: lugar.latitud, lng: lugar.longitud});
                        var modoViaje = document.getElementById('modoViaje').value;
                        calculateAndDisplayRoute(modoViaje);
                    });
                });
            }

            function calculateAndDisplayRoute(modo) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var origin = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                    var destinoB = puntosRuta[0];
                    var destinoC = puntosRuta[1];

                    var request = {
                        origin: origin,
                        destination: destinoB,
                        waypoints: [{location: destinoC, stopover: true}],
                        travelMode: modo
                    };

                    directionsService.route(request, function (result, status) {
                        if (status == 'OK') {
                            directionsRenderer.setDirections(result);
                        } else {
                            window.alert('No se pudo calcular la ruta: ' + status);
                        }
                    });
                });
            }

            function iniciarRuta() {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var userLocation = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    document.getElementById('ruta-info').innerHTML = '';
                    puntosRuta = [];
                    puntosRuta.push(userLocation);

                    var puntoB = lugares[0];
                    var modoViaje = document.getElementById('modoViaje').value;

                    calculateAndDisplayRoute(modoViaje);
                });
            }

            function elegirNuevaRuta() {
                document.getElementById('ruta-info').innerHTML = '';
                puntosRuta = [];
                directionsRenderer.setDirections({routes: []});
            }
        </script>
        <%
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (stmt != null) {
                        stmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </body>
</html>
