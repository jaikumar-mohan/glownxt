var HomePage = window.HomePage = {

  spinner_init: function () {
    $(document).on('click', '.sign_in input[type="submit"]', function () {
      $(this).parents('form').find( '.loading_spinner' ).show();
      $(this).hide();
    });
  },

  hide_spinner: function () {
    $( '.loading_spinner' ).hide();
    $( '.sign_in input[type="submit"]' ).show();
  },

  init: function () {
    HomePage.spinner_init();
  }

}