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
    submitRequest(origin, budget, depDate, retDate);
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
    sortDataBySaleTotal(data, origin, retDate);
    replaceSearchBox();
    // populateResultsTemp(data, origin, retDate);
  })
  .fail(function() {
    console.log("error");
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
function replaceSearchBox() {
  console.log("in replaceSearchBox");

  //fadein
    $(".result-text").fadeIn("slow");
}

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
  trackDataViaEmail(context, origin, retDate);
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
function trackDataViaEmail(context, origin, retDate) {
  $('#parent-container').on('click', '.email-button',  function(event){
    // var purchaseLink = "https://www.google.com/flights/#search;f="+origin+";t="+context[index].destination_code+";d="+departDate+";r="+retDate+";sel=*";
    var clickedElement = event.target.id
    event.preventDefault();
    console.log(context);
    var originalAirportCode = origin
    var returnDate = retDate
    var apiResponseObjects = context
    formDialog(clickedElement, originalAirportCode, returnDate, apiResponseObjects);
  });
}

function formDialog(clickedElement, originalAirportCode, returnDate, apiResponseObjects) {
  $("#dialog").dialog({
    autoOpen: false
  });
  $("#dialog").dialog("open");
  $('#dialog').css("display", 'block')

  sendEmail(clickedElement, originalAirportCode, returnDate, apiResponseObjects);
}

function sendEmail(clickedElement, originalAirportCode, returnDate, apiResponseObjects) {
  var divResultIndex = parseInt(clickedElement[6]);
  var departDate = apiResponseObjects[divResultIndex].depart_time.substring(0,10);
  var purchaseLink = "https://www.google.com/flights/#search;f="+originalAirportCode+";t="+apiResponseObjects[divResultIndex].destination_code+";d="+departDate+";r="+returnDate+";sel=*";

  $('form').on('submit', function(event) {
    event.preventDefault();
    debugger
    $.ajax({
      url: 'http://localhost:3000/users',
      type: 'post',
      dataType: 'json',
      data: {formData: ($('form').serializeArray()), purchaseLinkForEmail: purchaseLink},
    })
    .done(function(response) {
      console.log('success');
      console.log(response);
      debugger;
      $('#dialog').parent().remove();
    })
    .fail(function() {
      console.log("error");
    });
  });
}





