jQuery ->
  $("#issues_table").dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    # bProcessing: true
    # bServerSide: true
    # sAjaxSource: $('#issues').data('source')
    aoColumns: [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      # need to figure out how to sort those numbers, feel like the data params is 
      # not working right (doesn't allow sorting)
      # 
      asSorting: [ "asc", "desc" ]
    ]