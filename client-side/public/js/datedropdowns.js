console.log('datedropdowns.js');

function loadDatePicker() {

  // selects both departure and return date fields
  $('.search-params.datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    minDate: 0
  });

  replaceDepDatePlaceholder();
}

function replaceDepDatePlaceholder() {

  var today = new Date();
  var dd = today.getDate().toString();
  dd = lengthToTwo(dd);
  var mm = (today.getMonth() + 1).toString();
  mm = lengthToTwo(mm);
  var yy = today.getFullYear().toString();

  $('.search-params.datepicker#dep-date').attr('placeholder', yy+"-"+mm+"-"+dd);

  // takes the day from DepDatePlaceholder and adds 1
  replaceRetDatePlaceholder(yy,mm,dd);
} //end of replaceDepDatePlaceholder

function replaceRetDatePlaceholder(yy,mm,dd) {
  dd = (parseInt(dd)+1).toString();
  dd = lengthToTwo(dd);

  $('.search-params.datepicker#ret-date').attr('placeholder', yy+"-"+mm+"-"+dd);
}

function lengthToTwo(mmdd) {
  if (mmdd.length < 2) {
    mmdd = "0" + mmdd;
    return mmdd;
  } else {
    return mmdd;
  }
}
