jQuery ->
  $("#issues").dataTable
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"

    # sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#issues').data('source')
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 0, 1, 3, 4, 5 ] }
    ]
    "iDisplayLength": 25,
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
  $.extend( $.fn.dataTableExt.oStdClasses, {
    "sWrapper": "dataTables_wrapper form-inline"
  });
  $("#issues").show()


