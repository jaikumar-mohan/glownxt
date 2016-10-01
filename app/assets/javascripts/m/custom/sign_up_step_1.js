var SignUpStep1 = window.SignUpStep1 = {

  spinner_init: function () {
    $(document).on('click', '.sign_up_step_1 .s-btn', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.sign_up_step_1 .loading_spinner' ).hide();
    $( '.sign_up_step_1 .s-btn' ).show();
  },

  init: function () {
    SignUpStep1.spinner_init();
  }

}