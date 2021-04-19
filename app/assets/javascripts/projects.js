$(function() {
  function updateExpandAllState() {
    var target_rows = $("tr[data-uuid]");
    if (target_rows.filter(":hidden").length === 0) {
      // All rows visible
      $(".js-expand-all").removeClass("collapsed").addClass("expanded");
    } else if (target_rows.is(":visible")) {
      // Some rows visible
      $(".js-expand-all").removeClass("expanded").addClass("collapsed");
    } else {
      // No rows visible
      $(".js-expand-all").removeClass("expanded").addClass("collapsed");
    }
  }

  $(".js-expand").on('click', function(event) {
    var offer_uuid = $(event.target).attr('data-uuid');
    var target_rows = $("tr[data-uuid="+offer_uuid+"]");
    if (target_rows.is(":visible")) {
      target_rows.hide();
      $(event.target).removeClass("expanded").addClass("collapsed");
    } else {
      target_rows.show();
      $(event.target).removeClass("collapsed").addClass("expanded");
    }
    updateExpandAllState();
  });

  $(".js-expand-all").on('click', function(event) {
    var target_rows = $("tr[data-uuid]");
    if (target_rows.is(":visible")) {
      target_rows.hide();
      $(".js-expand").removeClass("expanded").addClass("collapsed");
      $(".js-expand-all").removeClass("expanded").addClass("collapsed");
    } else {
      target_rows.show();
      $(".js-expand").removeClass("collapsed").addClass("expanded");
      $(".js-expand-all").removeClass("collapsed").addClass("expanded");
    }
  });

  // Rows start collapsed by default
  $(".js-expand-all").addClass("collapsed");
  $(".js-expand").addClass("collapsed");
  $("tr[data-uuid]").hide();

});
