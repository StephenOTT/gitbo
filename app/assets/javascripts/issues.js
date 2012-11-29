// $("span#bounty-prompt").click(function(){
//   alert("please sign in with Github to post a bounty");
// });

// $("td#vote-prompt").click(function(){
//   alert("please sign in with Github to vote");
// });

// $("#bounty").click(function(){
//   alert("please sign in with Github to post a bounty");
// });

// $('div#refresh').click(function(){
//   location.reload();
// });

// $('div#endorse').click(function(){
//   $(this).removeAttr('style');
// });

// if ('<%= repo_owner %>'){
//    $('div#endorse').removeAttr('style');
//    }

$('#upvote_issue').click(function(){
  $('#upvote_issue').removeClass().addClass('btn btn-warning');
  $('#downvote_issue').removeClass().addClass('btn');

});
     
$('#downvote_issue').click(function(){
  $('#downvote_issue').removeClass().addClass('btn btn-warning');
  $('#upvote_issue').removeClass().addClass('btn');
});

// $('i#index_upvote.icon-arrow-up').click(function(){
//   $(this).toggleClass('icon-arrow-up icon-circle-arrow-up');
//   // $('i#index_downvote.icon-arrow-down').removeClass().addClass('icon-arrow-down');
// })

// $('i#index_downvote.icon-arrow-down').click(function(){
//   $(this).toggleClass('icon-circle-arrow-down icon-arrow-down ');
//   // $('i#index_upvote.icon-arrow-up').removeClass().addClass('icon-arrow-up');
// })

// $('i#index_upvote.icon-arrow-up, i#index_downvote.icon-arrow-down').click(function(e){
//   var $parent = $(this).parent(),
//   up = $parent.hasClass('icon-arrow-up');

//   $parent.toggleClass("icon-arrow-" + (up ? 'up' : 'down') + "-selected");
//   $parent.siblings().removeClass("icon-arrow-" + ()")

// })
