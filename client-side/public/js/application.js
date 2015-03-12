$(document).ready(function() {

  $(".load-icon").hide();
  infoOnHover();
  searchBarAutocomplete();
  loadDatePicker();
  eventListeners();
});

accumulatedLinks = []

function eventListeners() {
  console.log("in eventListeners");

  $(".button#send-request").on("click", function(event) {
    event.preventDefault();

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
    // $submitButton.attr('disabled', false).val('Submit');
    // $searchField.prop('disabled', false);
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
  trackDataViaEmail(context, origin, retDate);
  addToWishList(context, origin, retDate);
  trigger();
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
    $.ajax({
      url: 'http://localhost:3000/users',
      type: 'POST',
      dataType: 'json',
      data: {formData: ($('form').serializeArray()), purchaseLinkForEmail: purchaseLink},
    })
    .done(function(response) {
      $('#dialog').parent().remove();
    })
    .fail(function() {
      console.log("error");
    });
  });
}

// USER WISH LIST TO ACCUMULATE DESIRED RESULTS FOR EMAIL NOTIFICATION
function addToWishList(context, origin, retDate) {
    // var accumulatedLinks = [];
    var originalAirportCode = origin
    var returnDate = retDate
    var apiResponseObjects = context
  $('#parent-container').on('click', '.add-to-wishlist', function(event) {
    var clickedElement = event.target.id
    var index = parseInt(clickedElement[9])
    var currentDiv = apiResponseObjects[index]
    var destination = currentDiv.destination
    var carrier = currentDiv.carrier
    var saleTotal = "$ " + currentDiv.sale_total
    var departDate = currentDiv.depart_time.substring(0,10);
    var purchaseLink = "https://www.google.com/flights/#search;f="+origin+";t="+currentDiv.destination_code+";d="+departDate+";r="+returnDate+";sel=*";

    event.preventDefault();
      $('#table-body').append("<tr><td>"+destination+"</td><td>"+carrier+"</td><td>"+saleTotal+"</td></tr>"+"<td style='display:none'>"+purchaseLink+"</td>");
      accumulatedLinks.push(purchaseLink);
      console.log(accumulatedLinks)
  });
}
  function trigger() {
    $("#email-me").on('click', function(event) {
      var currentUserEmailAddress = $('#email-address').val();
      var currentUserName = $('#user-name').val();
      event.preventDefault();

      var payload = "";
      $.each(accumulatedLinks, function(index, value){
        payload += "<p>"+value+"</p>"
      })
      console.log(payload);
        $.ajax({
          type: 'POST',
          url: 'https://mandrillapp.com/api/1.0/messages/send.json',
          data: {
            "key": "E5DEVeyAdB1o6K-I_hXa6g",
            "message": {
              "from_email": "vineetrastogi@gmail.com",
              "to": [
                {
                  "email": currentUserEmailAddress,
                  "name": currentUserName,
                  "type": "to"
                },
              ],
              "inline_css": "true",
              "autotext": "true",
              "subject": "Get The Flight Out: Requested Links",

              "html": "<style>#hi{background-color: #DDDDDD; border: 2px solid black; padding: 15px}</style><img src='http://i.imgur.com/I5Wywsw.png'/><p>The prices on our homepage were specifically for one way trips. Prices may vary slightly as well.</p><p><strong>Here are the trips you requested:</strong></p><br><ul><div id='hi'>"+ payload + "</div></ul>",
              "send_at": "2014-04-29 12:12:12"
            }
          }
       }).done(function(response) {
         console.log(response); // if you're into that sorta thing
      }).error(function() {
         console.log("error");
      });
   });

  };
// }


























