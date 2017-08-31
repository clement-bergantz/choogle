function setAddressAutocomplete(selector) {
  var proposal_place = $(selector).get(0);

  if (proposal_place) {
    var autocomplete = new google.maps.places.Autocomplete(proposal_place, { types: ['geocode', 'establishment']}, {placeIdOnly: true});
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(proposal_place, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
}

function onPlaceChanged() {
  var place = this.getPlace();
}

function getAddressComponents(place) {
  var place_id = place.place_id;

 }
