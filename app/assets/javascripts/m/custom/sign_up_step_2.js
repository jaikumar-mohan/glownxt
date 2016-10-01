var SignUpStep2 = window.SignUpStep2 = {

  spinner_init: function () {
    $(document).on('click', '.sign_up_step_2_verification .s-btn', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.sign_up_step_2_verification .loading_spinner' ).hide();
    $( '.sign_up_step_2_verification .s-btn' ).show();
  },

  init: function () {
    SignUpStep2.spinner_init();
  }

}