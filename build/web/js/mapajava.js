var map;
var userLocation;
var directionsService;
var directionsDisplay;
var modeSelector;

function initMap() {
  map = new google.maps.Map(document.getElementById('map-container'), {
    center: { lat: 19.4326, lng: -99.1332 }, // Ciudad de México
    zoom: 12,
    mapTypeId: 'terrain' // Vista en 3D
  });

  directionsService = new google.maps.DirectionsService();
  directionsDisplay = new google.maps.DirectionsRenderer();
  directionsDisplay.setMap(map);

  modeSelector = document.getElementById('mode');

  document.getElementById('route-chapultepec').addEventListener('click', function () {
    calculateRoute({ lat: 19.4205, lng: -99.1866 });
  });

  document.getElementById('route-zocalo').addEventListener('click', function () {
    calculateRoute({ lat: 19.4326, lng: -99.1332 });
  });

  document.getElementById('route-aeropuerto').addEventListener('click', function () {
    calculateRoute({ lat: 19.4326, lng: -99.0720 });
  });

  document.getElementById('route-xochimilco').addEventListener('click', function () {
    calculateRoute({ lat: 19.2576, lng: -99.1076 });
  });

  document.getElementById('locate-button').addEventListener('click', locateUser);
}

function calculateRoute(destination) {
  var selectedMode = modeSelector.value;
  var request = {
    origin: userLocation,
    destination: destination,
    travelMode: google.maps.TravelMode[selectedMode]
  };
  directionsService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}

function locateUser() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function (position) {
      userLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      map.setCenter(userLocation);
    });
  }
}
