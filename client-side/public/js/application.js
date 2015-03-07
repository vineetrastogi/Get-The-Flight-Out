$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
  eventListeners();

});

function eventListeners() {

  $(".button#submit").on("click", function(event) {
    event.preventDefault();
    console.log("on button submit");

    var origin = $("#origin").val();
    var budget = $("#budget").val();
    var depDate = $("#dep-date").val();

    // uncomment below for full functionality
    // submitRequest(origin, budget, depDate);

    // to test fade in and fade out
    // replaceSearchBox();

    // to test handlebars template
    var data = [
      {"budget": "600", "carrier": "UA"},
      {"budget": "400", "carrier": "US"},
      {"budget": "800", "carrier": "KLM"}
    ];
    populateResultsTemp(data);
  });

}

function submitRequest(origin, budget, depDate) {
  console.log("submit request");

  $.ajax({
    url: "http://localhost:3000/index",
    type: "POST",
    dataType: "json",
    data: {"origin": origin, "depart_time": depDate, "sale_total": budget}
  })
  .done(function(data) {
    console.log("success");
    console.log(data);
    replaceSearchBox();
    populateResultsTemp(data);
    // data.forEach(function (object) {
    //   $('.results-wrapper').append(buildResultsTemplate(object.sale_total, object.carrier, object.carrier_code, object.flight_number, object.depart_time, object.origin, object.arrival_time, object.destination))
    // });
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });

}

function populateResultsTemp(data) {
  console.log('populateResultsTemp');
  console.log(data);

  var source = $('#results-template').html();
  var template = Handlebars.compile(source);
  var context = data;

  console.log(template(context));
  $('.results-wrapper').html(template(context));
  // $(document).html(templateWithContext);
}

function replaceSearchBox() {
  console.log('replaceSearchBox');

  $(".search-bar-wrapper").animate({ opacity:0 }, fadeInTextBox());
  // fadeOut("slow", fadeInTextBox());

  function fadeInTextBox() {
    $('.result-text').fadeIn("4000");
  } //fadein

}

// function buildResultsTemplate(budget, carrier, carrierCode, flightNumber, departingTime, origin, arrivalTime, destination) {
//   var template = $.trim($('.container.results').html());
//   var $displayTemplate = $(template);
//   $replacePrice = $($displayTemplate.children($('.flight.price'))[0]);
//   $replacePrice.text(budget);
//   $replaceCarrier = $($displayTemplate.children($('.flight.price'))[1]);
//   $replaceCarrier.text(carrier);
//   $replaceCarrierCode = $($displayTemplate.children($('.flight.price')).children()[0]);
//   $replaceCarrierCode.text(carrierCode);
//   $replaceFlightNumber = $($displayTemplate.children($('.flight.price')).children()[1]);
//   $replaceFlightNumber.text(flightNumber);
//   $replaceDepartureTime = $($displayTemplate.children($('.flight.price'))[2]);
//   $replaceDepartureTime.text(departingTime);
//   $replaceOrigin = $($($displayTemplate.children($('.flight.price'))[2]).children()[0]);
//   $replaceOrigin.text(origin);
//   $replaceArrivalTime = $($($displayTemplate.children($('.flight.price'))[2]).children()[1]);
//   $replaceArrivalTime.text(arrivalTime);
//   $replaceDestination = $($($displayTemplate.children($('.flight.price'))[2]).children()[2]);
//   $replaceDestination.text(destination);

//   return $displayTemplate;
// }

