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

//grab the numeric values of two fields
//compare and make sure they are the same
//submit form or return error
//need to prevent default for button if wrong
//need to post a notice if wrong
//goes through if match

  $('button#pledge').live(
    "click", (function() {
    pageValue = $('#bounty_price_page').val();
    modalValue(pageValue);
  }));
  
  function modalValue(pageValue) {
    $('#create-bounty').live(
    "click", (function(event) {
    modal = $('#bounty_price').val();
    
    if(parseInt(modal)!=parseInt(pageValue)){
      event.preventDefault();
      $('span#error').replaceWith('<span class="label label-important">Please Enter The Same Value</span>');
    }

    if(parseInt(modal) >= 5000){
      event.preventDefault();
      $('span#error').replaceWith('<span class="label label-important">That is a lot of Moola! Please enter something more realistic.</span>');
    }
    
  }));
}

function focusBountyForm()
{
  if ($('#bounty_price_page').length == 0){

    $('#new_link').trigger('click').ajaxComplete(function(){
        setTimeout(function(){
          $('#bounty_price_page').focus()
        }, 100);
      });
  }
}


$('#nevermind').click(function(){
  location.reload();
});


  var url = window.location.href.split('?');
  url.splice(0,1)
  var query_string_params = url[0].split("&");
  if (($.inArray("bounty=true", query_string_params)) != -1) {
    focusBountyForm();
    }






