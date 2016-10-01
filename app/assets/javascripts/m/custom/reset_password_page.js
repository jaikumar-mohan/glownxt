var ResetPassword = window.ResetPassword = {

  spinner_init: function () {
    $(document).on('click', '.reset_password .s-btn', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.reset_password .loading_spinner' ).hide();
    $( '.reset_password .s-btn' ).show();
  },

  show_success_message: function () {
    $( '.b-page-header__description' ).text("Email sent with password reset instructions.");
    $( '.reset_password .s-form' ).fadeOut();
  },  

  init: function () {
    ResetPassword.spinner_init();
  }

}