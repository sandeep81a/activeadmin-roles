// Active Admin - Roles

(function(AA, $, undefined){

  AA.Roles = {};

  AA.Roles.init = function(){
    $(".permissions-table .permission-row-title").click(AA.Roles.onClickRowTitle);
    $(".permissions-table .permission-column-title").click(AA.Roles.onClickColumnTitle);
  }

  AA.Roles.onClickRowTitle = function(){
    var inputs = AA.Roles.checkboxesForRow($(this));
    checkOrUncheckInputs(inputs)

    return false;
  }

  AA.Roles.onClickColumnTitle = function(){
    var inputs = AA.Roles.checkboxesForColumn($(this));
    checkOrUncheckInputs(inputs)

    return false;
  }

  function isAllChecked(inputs){
    return inputs.not(":checked").size() == 0
  }

  function checkOrUncheckInputs(inputs){
    if(isAllChecked(inputs)) {
      inputs.attr("checked", false);
    } else {
      inputs.attr("checked", true);
    }
  }

  AA.Roles.checkboxesForRow = function(heading) {
    var row = heading.closest("tr");
    return row.find("input[type=checkbox]");
  }

  AA.Roles.checkboxesForColumn = function(heading) {
      var table = heading.closest(".permissions-table");
      var columnIndex = table.find("th").index(heading);

      return table.find("tr td:nth-child("+(columnIndex+1)+") input[type=checkbox]");
  }

  $(function(){ AA.Roles.init(); });

})(AA, jQuery);
