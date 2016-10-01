var SignUpStep3 = window.SignUpStep3 = {

  spinner_init: function () {
    $(document).on('click', '.sign_up_3 .s-form__footer .s-btn', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.sign_up_3 .loading_spinner' ).hide();
    $( '.sign_up_3 .s-form__footer .s-btn' ).show();
  },

  init: function () {
    SignUpStep3.spinner_init();
  }

}