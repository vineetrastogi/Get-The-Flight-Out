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
    var retDate = $("#ret-date").val();

    // uncomment below in order to make ajax post request
    // leads to replaceSearchBox and populateResultsTemp
    // add retDate
    submitRequest(origin, budget, depDate, retDate);

    // to test fade in and fade out
    // replaceSearchBox();

    // to test handlebars template
    //LEGIT FLIGHT!!!
    // var data = [
    //   {"index": 0, "budget": "80", "carrier": "Virgin America", "carrier_code": "VX", "flight_number" :"906", "depart_time" :"2015-03-23", "origin":"SFO" , "arrival_time":"2015-03-27" , "destination":"LAS" },
    //   {"index": 1, "budget": "1800", "carrier": "United Airlines", "carrier_code": "UA", "flight_number" :"990", "depart_time" :"2015-03-13", "origin":"SFO" , "arrival_time":"2015-03-27" , "destination":"CDG"},
    //   {"index": 2, "budget": "900", "carrier": "United Airlines", "carrier_code": "UA", "flight_number" :"837", "depart_time": "2015-03-16", "origin":"SFO" , "arrival_time":"2015-03-18" , "destination":"NRT"}
    // ];
    // populateResultsTemp(data, retDate);
  }); //end of on click
}

function submitRequest(origin, budget, depDate, retDate) {
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
    populateResultsTemp(data, retDate);
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });

} //end of submitRequest

// called in submitRequest callback when successful
function replaceSearchBox() {
  console.log("in replaceSearchBox");

  // fadeOut
  $(".search-bar-wrapper").animate({ opacity:0 }, fadeInTextBox());

  //fadein
  function fadeInTextBox() {
    $(".result-text").fadeIn("4000");
  }
}

// called in submitRequest callback when successful
function populateResultsTemp(data, retDate) {
  console.log("in populateResultsTemp");
  console.log(retDate+"***********");
  console.log(data);

  var source = $("#results-template").html();
  var template = Handlebars.compile(source);
  var context = data;

  console.log(template(context));
  $(".results-wrapper").html(template(context));

  // directs on "click" event listener to redirect user to googleflights ticket purchse
  redirectToPurchase(data, retDate);
}

function redirectToPurchase(data, retDate) {
  $(".button#purchase").on("click", function(event) {
    event.preventDefault();

    console.log('in redirectToPurchase');
    console.log(retDate+"***********");

    // grab data attribute value of button that was clicked
    var indexString = $(this).attr("data");
    var index = parseInt(indexString);

    var purchaseLink = "https://www.google.com/flights/#search;f="+data[index].origin+";t="+data[index].destination+";d="+data[index].depart_time+";r="+retDate+";sel="+data[index].origin+data[index].destination+"0"+data[index].carrier_code+""+data[index].flight_number+";mp="+data[index].budget;

    console.log(purchaseLink);

    window.open(purchaseLink);
  });
}
