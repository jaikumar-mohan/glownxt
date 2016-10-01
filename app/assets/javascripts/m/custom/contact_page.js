var ContactPage = window.ContactPage = {

  spinner_init: function () {
    $(document).on('click', '.contact_page .s-btn', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.contact_page .loading_spinner' ).hide();
    $( '.contact_page .s-btn' ).show();
  },

  show_success_message: function () {
    $( '.b-page-header__description' ).text("Thank you! Your message has been sent and will be reviewed as soon as possible.");
    $( '.contact_page .s-form' ).fadeOut();
  },

  init: function () {
    ContactPage.spinner_init();
  }

}