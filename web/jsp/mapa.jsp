<%@ page import="connectionDataBase.connection"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <link rel="stylesheet" type="text/css" href="../CSS/mapastyle.css">
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mi Mapa</title>
        <style>
            #map {
                float: right;
                height: 100vh;
                width: 50vw;
            }

            #ruta-info {
                float: left;
                width: 45vw;
                padding: 10px;
            }

            #contenedor-botones {
                clear: both;
                padding-top: 10px;
            }
        </style>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDXhXtV1rMD-5y15llNS1fFMl8u8TvVBoo&callback=initMap" async defer></script>
    </head>
    <body>
        <%@ page import="com.google.gson.Gson" %>
        <%@page import="java.util.Map"%>
        <%@page import="java.util.HashMap"%>
        <%@page import="java.sql.*" %>
        <%@page import="java.util.List" %>
        <%@page import="java.util.ArrayList" %>
        <%

            Connection cnx = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                connection connection = new connection();
                cnx = connection.connectionAction();
                List<Map<String, Object>> ubicaciones = new ArrayList<>();
                stmt = cnx.createStatement();
                rs = stmt.executeQuery("SELECT * FROM ubicacion");

                while (rs.next()) {
                    Map<String, Object> ubicacion = new HashMap<>();
                    ubicacion.put("nombre", rs.getString("nombreUbicacion"));
                    ubicacion.put("latitud", rs.getDouble("latitud"));
                    ubicacion.put("longitud", rs.getDouble("longitud"));
                    ubicaciones.add(ubicacion);
                }
        %>
        <div  cass="columna">
            <h1>TripTrove</h1>
            <h3>Tu guía viajero</h3>
            <h2>Opciones de llegada</h2>
            <div class="drodown">
                <select id="modoViaje" class="Dropdown menu">
                    <div class="options">

                        <option value="WALKING">Caminando</option>
                        <option value="DRIVING">Manejando</option>
                    </div>
                </select>
            </div>
            <div id="contenedor-botones">
                <button onclick="elegirNuevaRuta()" class="cta">
                    <span>Nueva ruta</span>
                    <svg viewBox="0 0 13 10" height="10px" width="15px">
                    <path d="M1,5 L11,5"></path>
                    <polyline points="8 1 12 5 8 9"></polyline>
                    </svg>
                </button>
            </div>
        </div>
        <div id="map"></div>
        <div id="ruta-info"></div>
        <script>
            var ubicacionesJSON = <%= new Gson().toJson(ubicaciones)%>;
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

                // ... (resto del cï¿½digo igual)

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
                    if (cnx != null) {
                        cnx.close();
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>

    </body>
</html>







