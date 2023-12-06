<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
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
                position: fixed;
                top: 50%;
                left: 0;
                transform: translateY(-50%);
                padding: 10px;
                box-sizing: border-box;
                background-color: white;
                z-index: 1;
                text-align: center;
            }

            #contenedor-botones button {
                margin-bottom: 10px;
                display: block;
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
                String password = "1234";
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

        <div id="contenedor-botones">
            <label for="modoViaje">Elegir modo de viaje:</label>
            <select id="modoViaje">
                <option value="WALKING">Caminando</option>
                <option value="DRIVING">Manejando</option>
            </select>
            <button onclick="iniciarRuta()">Iniciar Ruta</button>
            <button onclick="elegirNuevaRuta()">Elegir Nueva Ruta</button>
            <button onclick="buscarLugares('bar')">Buscar Bares</button>
            <button onclick="buscarLugares('restaurant')">Mostrar Restaurantes</button>
            <button onclick="buscarLugares('park')">Mostrar Parques</button>
        </div>

        <div id="map"></div>
        <div id="ruta-info"></div>

        <script>
            var ubicacionesJSON = <%= new Gson().toJson(ubicaciones)%>;

            var lugares = ubicacionesJSON;
            var directionsService, directionsRenderer, lugaresService;
            var puntosRuta = [];

            function initMap() {
                var map = new google.maps.Map(document.getElementById('map'), {
                    center: {lat: 19.4326, lng: -99.1332},
                    zoom: 12
                });

                directionsService = new google.maps.DirectionsService();
                directionsRenderer = new google.maps.DirectionsRenderer({
                    suppressMarkers: true,
                    panel: document.getElementById('ruta-info')
                });
                directionsRenderer.setMap(map);

                lugaresService = new google.maps.places.PlacesService(map);

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
                        puntosRuta = [];
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

                    var request = {
                        origin: origin,
                        destination: destinoB,
                        waypoints: [],
                        travelMode: modo
                    };

                    directionsService.route(request, function (result, status) {
                        if (status === 'OK') {
                            directionsRenderer.setDirections(result);
                        } else {
                            window.alert('No se pudo calcular la ruta: ' + status);
                        }
                    });
                });
            }

            function iniciarRuta() {
                // Simplemente llama a calculateAndDisplayRoute con el modo actual
                var modoViaje = document.getElementById('modoViaje').value;
                calculateAndDisplayRoute(modoViaje);
            }

            function elegirNuevaRuta() {
                document.getElementById('ruta-info').innerHTML = '';
                puntosRuta = [];
                directionsRenderer.setDirections({routes: []});
            }

            function buscarLugares(tipo) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var ubicacion = {
                        lat: position.coords.latitude,
                        lng: position.coords.longitude
                    };

                    var request = {
                        location: ubicacion,
                        radius: 5000,
                        type: [tipo]
                    };

                    lugaresService.nearbySearch(request, function (results, status) {
                        if (status === google.maps.places.PlacesServiceStatus.OK) {
                            mostrarLugares(results);
                        } else {
                            window.alert('No se pudo cargar los lugares: ' + status);
                        }
                    });
                });
            }

            function mostrarLugares(lugares) {
                var infoPanel = document.getElementById('ruta-info');
                infoPanel.innerHTML = '';

                lugares.forEach(function (lugar) {
                    infoPanel.innerHTML += '<p>' + lugar.name + '</p>';
                });
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
