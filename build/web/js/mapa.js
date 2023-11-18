function initMap() {
  // Coordenadas de la Ciudad de México
  var ciudadDeMexicoBounds = {
    north: 19.6415,
    south: 19.1635,
    east: -98.9346,
    west: -99.3545
  };

  // Crear un nuevo mapa y asociarlo con el elemento div con el id "map"
  var map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: 19.4326, lng: -99.1332 }, // Coordenadas centradas en la Ciudad de México
    zoom: 10, // Nivel de zoom inicial
    restriction: {
      latLngBounds: ciudadDeMexicoBounds,
      strictBounds: false
    }
  });

  // Restringir el área visible del mapa a la Ciudad de México
  map.addListener('dragend', function() {
    if (ciudadDeMexicoBounds.contains(map.getCenter())) return;

    // Si el centro del mapa está fuera de los límites, ajustarlo de vuelta
    var c = map.getCenter(),
        x = c.lng(),
        y = c.lat(),
        maxX = ciudadDeMexicoBounds.east,
        maxY = ciudadDeMexicoBounds.north,
        minX = ciudadDeMexicoBounds.west,
        minY = ciudadDeMexicoBounds.south;

    if (x < minX) x = minX;
    if (x > maxX) x = maxX;
    if (y < minY) y = minY;
    if (y > maxY) y = maxY;

    map.setCenter(new google.maps.LatLng(y, x));
  });

  // ... Resto de tu código de inicialización del mapa
}
