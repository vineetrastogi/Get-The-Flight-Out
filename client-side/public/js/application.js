$(document).ready(function() {

  eventListeners();

});

function eventListeners() {
  console.log("in eventListeners")

  $(".button#submit").on("click", function(event) {
    event.preventDefault();
    console.log("in .button#submit on click");

    var origin = $("#origin").val();
    var budget = $("#budget").val();
    var depDate = $("#dep-date").val();

    // uncomment below in order to make ajax post request
    // leads to replaceSearchBox and populateResultsTemp
    submitRequest(origin, budget, depDate);

    // to test fade in and fade out
    // replaceSearchBox();

    // to test handlebars template
    // var data = [
    //   {"budget": "600", "carrier": "United Airlines", "carrier_code": "UA", "flight_number" :"71", "depart_time" :"13:45", "origin":"SFO" , "arrival_time":"13:67" , "destination":"LAS" },
    //   {"budget": "400", "carrier": "USA Airways", "carrier_code": "US", "flight_number" :"415", "depart_time" :"12:22", "origin":"SJS" , "arrival_time":"14:45" , "destination":"MIA"},
    //   {"budget": "800", "carrier": "Royal Dutch Airlines", "carrier_code": "KLM", "flight_number" :"360", "depart_time": "21:12", "origin":"MNL" , "arrival_time":"5:00" , "destination":"SFO"}
    // ];
    // populateResultsTemp(data);
  });
}

function submitRequest(origin, budget, depDate) {
  console.log("in submitRequest");

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
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });

}

// called in submitRequest callback when successful
function replaceSearchBox() {
  console.log('in replaceSearchBox');

  // fadeOut
  $(".search-bar-wrapper").animate({ opacity:0 }, fadeInTextBox());

  //fadein
  function fadeInTextBox() {
    $('.result-text').fadeIn("4000");
  }
}

// called in submitRequest callback when successful
function populateResultsTemp(data) {
  console.log('in populateResultsTemp');
  console.log(data);

  var source = $('#results-template').html();
  var template = Handlebars.compile(source);
  var context = data;

  console.log(template(context));
  $('.results-wrapper').html(template(context));
}
