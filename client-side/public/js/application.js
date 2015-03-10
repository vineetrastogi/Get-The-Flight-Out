$(document).ready(function() {

  $(".load-icon").hide();
  searchBarAutocomplete();
  loadDatePicker();
  eventListeners();

});

function eventListeners() {
  console.log("in eventListeners");

  $(".button#submit").on("click", function(event) {
    event.preventDefault();

    // change button to loading and prevents user from typing in search field while ajax request is still going
    $(".search-params#origin").prop("disabled", true);
    $(".button#submit").attr("disabled", true).val('......');
    $(".search-bar-wrapper").animate({ opacity:0 });
    $(".load-icon").show();

    var origin = $("#origin").val().match(/\(([^)]+)\)/)[1];
    var budget = $("#budget").val();
    var depDate = $("#dep-date").val();
    var retDate = $("#ret-date").val();

    // uncomment below in order to make ajax post request
    // leads to replaceSearchBox and populateResultsTemp
    // add retDate?
    submitRequest(origin, budget, depDate, retDate);

    // to test fade in and fade out
    // replaceSearchBox();

    // to test handlebars template
    //LEGIT FLIGHT!!!
    // var data = {
    //   trips: [
    //   {"index": 0, "sale_total": "80", "carrier": "Virgin America", "carrier_code": "VX", "flight_number" :"906", "depart_time" :"2015-03-23 at 9:00", "origin":"SFO" , "arrival_time":"2015-03-27 at 10:00" , "destination":"LAS" },
    //   {"index": 1, "sale_total": "1800", "carrier": "United Airlines", "carrier_code": "UA", "flight_number" :"990", "depart_time" :"2015-03-13 at 9:00", "origin":"SFO" , "arrival_time":"2015-03-27 at 10:00" , "destination":"CDG"},
    //   {"index": 2, "sale_total": "900", "carrier": "United Airlines", "carrier_code": "UA", "flight_number" :"837", "depart_time": "2015-03-16 at 9:00", "origin":"SFO" , "arrival_time":"2015-03-18 at 10:00" , "destination":"NRT"}]
    // };
    // populateResultsTemp(data, origin, retDate);
  }); //end of on click
}

function submitRequest(origin, budget, depDate, retDate) {
  console.log("in submitRequest");
  console.log(origin, budget, depDate, retDate);
  console.log("*************************");

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
    populateResultsTemp(data, origin, retDate);
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
    $(".load-icon").hide();
  });

} //end of submitRequest

// called in submitRequest callback when successful
function replaceSearchBox() {
  console.log("in replaceSearchBox");

  // fadeOut
  // $(".search-bar-wrapper").animate({ opacity:0 }, fadeInTextBox());

  //fadein
  // function fadeInTextBox() {
    $(".result-text").fadeIn("slow");
  // }
}

// called in submitRequest callback when successful
function populateResultsTemp(data, origin, retDate) {
  console.log("in populateResultsTemp");
  console.log(data, origin, retDate);

  // FOR TESTING ONLY
  // var depDate = depDate;
  //   depDate = "REPLACE THIS";
  // $('.date-time#departure').children().text(depDate);

  var source = $("#results-template").html();
  var template = Handlebars.compile(source);
    // debugger;
    var context = data.trips;

    $(".results-wrapper").html(template(context));

  // directs on "click" event listener to redirect user to googleflights ticket purchse
  redirectToPurchase(context, origin, retDate);
  trackDataViaEmail();

}

// POP UP WINDOW FOR USER TO INSERT NAME AND EMAIL TO RECEIVE PUSH NOTIFICATION
function trackDataViaEmail() {

  $('.button#email').on('click', function(event){
    event.preventDefault();
    var trackButton = $(this).attr('data')
    console.log(trackButton);
    formDialog(trackButton);
  });
}

function formDialog(trackButton) {
  $("#dialog").dialog({
    autoOpen: false
  });
  $(".email-button").on("click", function() {
    $("#dialog").dialog("open");
    $('#dialog').css("display", 'block')
    sendEmail(trackButton);
  });
}

function sendEmail(trackButton) {
  $('form').on('submit', function(event) {
    event.preventDefault();

    $.ajax({
      url: 'http://localhost:3000/users',
      type: 'post',
      dataType: 'json',
      data: $('form').serialize()
    })
    .done(function(response) {
      console.log('success');
      console.log(response);
      $('#dialog').parent().css("display", "none");
    })
    .fail(function() {
      console.log("error");
    });
  });
}

// Validating Form Fields.....
// $("#submit").click(function(e) {
//   var email = $("#email").val();
//   var name = $("#name").val();
//   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
//   if (email === '' || name === '') {
//     alert("Please fill all fields...!!!!!!");
//     e.preventDefault();
//   } else if (!(email).match(emailReg)) {
//     alert("Invalid Email...!!!!!!");
//     e.preventDefault();
//   } else {
//     alert("Form Submitted Successfully......");
//   }
// });


function redirectToPurchase(context, origin, retDate) {
  $(".button#purchase").on("click", function(event) {
    event.preventDefault();

    console.log('in redirectToPurchase');
    console.log("*************************");

    // grab data attribute value of button that was clicked
    var indexString = $(this).attr("data");
    var index = parseInt(indexString);
    var departDate = context[index].depart_time.substring(0,10);
    console.log(context);

    var purchaseLink = "https://www.google.com/flights/#search;f="+origin+";t="+context[index].destination_code+";d="+departDate+";r="+retDate+";sel=*";

    console.log(purchaseLink);

    window.open(purchaseLink);
  });
}
