jQuery ->
  $("#issues_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#issues').data('source')
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 0, 1, 3, 4, 5 ] }
    ]
    "iDisplayLength": 25,
    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
  $("#issues_table").show()
