console.log('helpers.js');

Handlebars.registerHelper("durationInHours", function(duration){
  var durationHours = Math.floor(duration / 60)
  return durationHours
});

Handlebars.registerHelper("durationInMinutes", function(duration){
  var durationHours = Math.floor(duration / 60)
  var durationMinutes = duration % (durationHours * 60)
  return durationMinutes
});

Handlebars.registerHelper("ifCondition", function(num_of_stop){
  if (num_of_stop > 0) {
    return num_of_stop + " stop";
  }
  return "nonstop";
})
