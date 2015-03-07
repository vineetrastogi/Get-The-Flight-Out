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

    // submitRequest(origin, budget, depDate);

    // to test fade in and fade out
    replaceSearchBox();
  });

}

function submitRequest(origin, budget, depDate) {
  console.log("submit request");

  $.ajax({
    url: "http://localhost:3000/index",
    type: "POST",
    dataType: "json",
    data: {"origin": origin, "date": depDate, "maxPrice": budget}
  })
  .done(function(data) {
    console.log("success");
    console.log(data);
    replaceSearchBox();
  })
  .fail(function() {
    console.log("error");
  })
  .always(function() {
    console.log("complete");
  });

}

function replaceSearchBox() {
  console.log('replaceSearchBox');

  $(".search-bar-wrapper").fadeOut(300, fadeInTextBox());

  function fadeInTextBox() {
    $('.result-text').fadeIn("slow");
  } //fadein

}

