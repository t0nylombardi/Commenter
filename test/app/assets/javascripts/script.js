jQuery.fn.fadeThenSlideToggle = function(speed, easing, callback) {
  if (this.is(":hidden")) {
    return this.slideDown(speed, easing).fadeTo(speed, 1, easing, callback);
  } else {
    return this.fadeTo(speed, 0, easing).slideUp(speed, easing, callback);
  }
};

$('document').ready(function() {

$('#supplier_registration_form').validate({
    
    onkeyup: false,
    ignore: ":hidden",

    rules: {
      firstName:         { required: true },
      LastName:          { required: true },
      email:             { required: true },
      reEmail:           { required: true },
      inviteCode:        { required: true },
    },
    messages: {
      inviteCode:  'Must Have invite code to become a member of this site'
    }  
  });



  $("#submit").click(function(){    

  });
});

