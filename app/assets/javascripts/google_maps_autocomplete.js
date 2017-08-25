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
  // var components = getAddressComponents(place);
  // $('#proposal_place').trigger('blur').val(place);
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  var place_id = place.place_id;

 }
//
 //   return {
 //     address: street_number == null ? route : (street_number + ' ' + route),
 //     zip_code: zip_code,
 //     city: city,
 //     country_code: country_code
 //   };
 // }
