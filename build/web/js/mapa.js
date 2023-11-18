var map;

function initMap() {
    var ciudadDeMexicoBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(19.1635, -99.3545),
        new google.maps.LatLng(19.6415, -98.9346)
    );

    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 19.4326, lng: -99.1332 },
        zoom: 10,
        restriction: {
            latLngBounds: ciudadDeMexicoBounds,
            strictBounds: false
        }
    });

    getLocation();
}

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.watchPosition(showPosition, showError);
    } else {
        document.getElementById("demo").innerHTML = "Geolocalización no es compatible con este navegador.";
    }
}

function showPosition(position) {
    // Commenting out the following line will prevent displaying latitude and longitude
    // document.getElementById("demo").innerHTML = "Latitud: " + position.coords.latitude + "<br>Longitud: " + position.coords.longitude;

    map.setCenter({
        lat: position.coords.latitude,
        lng: position.coords.longitude
    });

    var marker = new google.maps.Marker({
        position: {
            lat: position.coords.latitude,
            lng: position.coords.longitude
        },
        map: map,
        title: 'Ubicación en Tiempo Real'
    });
}

function showError(error) {
    switch (error.code) {
        case error.PERMISSION_DENIED:
            document.getElementById("demo").innerHTML = "Usuario denegó la solicitud de geolocalización.";
            break;
        case error.POSITION_UNAVAILABLE:
            document.getElementById("demo").innerHTML = "Información de ubicación no disponible.";
            break;
        case error.TIMEOUT:
            document.getElementById("demo").innerHTML = "Tiempo de espera agotado para la solicitud de geolocalización.";
            break;
        case error.UNKNOWN_ERROR:
            document.getElementById("demo").innerHTML = "Ocurrió un error desconocido.";
            break;
    }
}

function generateRoute() {
    var destination = document.getElementById("destination").value;

    if (destination.trim() === "") {
        alert("Por favor, ingresa una ubicación válida.");
        return;
    }

    var directionsService = new google.maps.DirectionsService();
    var directionsRenderer = new google.maps.DirectionsRenderer();

    directionsRenderer.setMap(map);

    var request = {
        origin: new google.maps.LatLng(map.center.lat(), map.center.lng()),
        destination: destination,
        travelMode: google.maps.TravelMode.DRIVING,
    };

    directionsService.route(request, function (result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            directionsRenderer.setDirections(result);
        } else {
            alert("No se pudo calcular la ruta. Asegúrate de ingresar una ubicación válida.");
        }
    });
}
