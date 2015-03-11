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

    // $(".search-bar-wrapper").animate({ opacity:0 });
    // change button to loading and prevents user from typing in search field while ajax request is still going
    // $(".search-params#origin").prop("disabled", true);
    // $(".button#submit").attr("disabled", true).val('......');
    // $(".load-icon").show();

    var origin = $("#origin").val().match(/\(([^)]+)\)/)[1];
    var budget = $("#budget").val();
    var depDate = $("#dep-date").val();
    var retDate = $("#ret-date").val();

    //checks that all inputs fields have input
    checkForBlankInputs(origin, budget, depDate, retDate);

    // uncomment below in order to make ajax post request
    // leads to replaceSearchBox and populateResultsTemp
    // call submitRequest from hasBlankInput if all inputs are present -- WORKING
    // submitRequest(origin, budget, depDate, retDate);
  }); //end of on click
}

function submitRequest(origin, budget, depDate, retDate) {
  console.log("in submitRequest");
  console.log(origin, budget, depDate, retDate);
  console.log("*************************");
  // display loading icon
  $(".search-bar-wrapper").animate({ opacity:0 });
  $(".load-icon").show();

  $.ajax({
    url: "http://localhost:3000/index",
    type: "POST",
    dataType: "json",
    data: {"origin": origin, "depart_time": depDate, "sale_total": budget}
  })
  .done(function(data) {
    console.log("success");
    console.log(data);
    // replaceSearchBox();
    checkForNoResults(data, origin, retDate);
    // error handling when array[0];
    // now called from checkForNoResults fxn
    // sortDataBySaleTotal(data, origin, retDate);
  })
  .fail(function() {
    console.log("error");
    // in errorhandling.js
    displayApologyText();
    errorInvalidRequest();
  })
  .always(function() {
    console.log("complete");
    $(".load-icon").hide();
  });

} //end of submitRequest

function sortDataBySaleTotal(data, origin, retDate) {
  var response = data.trips;
  var sortAsc = [];

  for (var key in response) {
    sortAsc.push({key:key,sale_total:response[key].sale_total});
  }

  sortAsc.sort(function(x,y) {
    return x.sale_total - y.sale_total;
  })

  var data_array = [];

  for (var i = 0; i< sortAsc.length; i++) {
    data_array.push(response[sortAsc[i].key]);
  }

  populateResultsTemp(data_array, origin, retDate);
}

// called in submitRequest callback when successful
// function replaceSearchBox() {
//   console.log("in replaceSearchBox");

//   //fadein
//     $(".result-text").fadeIn("slow");
// }

// called in submitRequest callback when successful
function populateResultsTemp(data_array, origin, retDate) {
  console.log("in populateResultsTemp");
  console.log(data_array, origin, retDate);

  var source = $("#results-template").html();
  var template = Handlebars.compile(source);
  var context = data_array;

  $(".results-wrapper").html(template(context));

  // directs on "click" event listener to redirect user to googleflights ticket purchse
  redirectToPurchase(context, origin, retDate);
  trackDataViaEmail();
}

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

// POP UP WINDOW FOR USER TO INSERT NAME AND EMAIL TO RECEIVE PUSH NOTIFICATION
function trackDataViaEmail() {
  $('#parent-container').on('click', '.email-button',  function(event){
    var clickedElement = event.target.id
    event.preventDefault();
    console.log(clickedElement);
    formDialog(clickedElement);
  });
}

function formDialog(clickedElement) {
  $("#dialog").dialog({
    autoOpen: false
  });
  $("#dialog").dialog("open");
  $('#dialog').css("display", 'block')
  sendEmail(clickedElement);
}

function sendEmail(clickedElement) {
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
      $('#dialog').parent().remove();
    })
    .fail(function() {
      console.log("error");
    });
  });
}



