console.log('errorhandling.js');

// called from eventListeners on click -- SHAKES SUCCESSFULLY
function checkForBlankInputs(origin, budget, depDate, retDate) {
  if (origin === "" || budget === "" || depDate === "" || retDate === "") {
    console.log('origin/budget/depDate/retDate is blank');
    $('.search-params').addClass('animated shake');
  } else {
    console.log('no errors, go to submitRequest')
    submitRequest(origin, budget, depDate, retDate);
  }
}

// called from submitRequest if ajax request fails -- WORKING
function displayApologyText() {
  $(".load-icon").hide();
  $(".apology-text").fadeIn("slow");

  $('.refresh .button').click(function(){
    location.reload();
  })
}

function checkForNoResults(data, origin, retDate) {
  if (data.trips.length === 0) {
    $(".no-flights-text").fadeIn("slow");
  } else {
    $(".result-text").fadeIn("slow");
    sortDataBySaleTotal(data, origin, retDate);
  }
}
