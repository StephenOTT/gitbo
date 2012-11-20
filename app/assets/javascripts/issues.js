$("span#bounty-prompt").click(function(){
  alert("please sign in with Github to post a bounty");
});

$("td#vote-prompt").click(function(){
  alert("please sign in with Github to vote");
});

$("#bounty").click(function(){
  alert("please sign in with Github to post a bounty");
});

$('div#refresh').click(function(){
  location.reload();
});

// $('div#endorse').click(function(){
//   $(this).removeAttr('style');
// });

 if ('<%= repo_owner %>'){
    $('div#endorse').removeAttr('style');
    }

// $(document).ready(function() {
//   $('#issues_table').dataTable( {
//     "aoColumns": [
//       null,
//       { "asSorting": [ "asc" ] },
//       { "asSorting": [ "desc", "asc", "asc" ] },
//       { "asSorting": [ "desc" ] },
//       null
//     ]
//   } );
// } );
