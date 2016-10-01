var ProfilePage = window.ProfilePage = {

  gravatar_popup: function () {
    $(document).on('click', 'a[data-popup]', function (e) {
      window.open($(this)[0].href);
      e.preventDefault();
    });
  },

  textarea_limitation: function () {
    $( '.s-textarea textarea' ).each(function( key, value ) {

      $(document).on('keyup', $(value), function () {
        ProfilePage.check_textarea_limit( $(value) );
      });

      ProfilePage.check_textarea_limit( $(value) );
      
    });
  },

  check_textarea_limit: function ( textarea ) {
    var limit_message = textarea.parents('.company_services_block').find('.countdown');
    var limit = limit_message.attr('data-limit');

    var remaining = limit - textarea.val().length;
    if (remaining >= 0)
      limit_message.text(remaining + ' characters remaining');
    else {
      var max_text = textarea.val().substring(0, limit);
      textarea.val(max_text);
      limit_message.text('0 characters remaining');
    }
  },

  spinner_init: function () {
    $(document).on('click', '.b-profile__submit', function () {
      ProfilePage.hide_all_messages();
      $(this).parents('form').find('.loading_spinner').show();
      $(this).hide();
    });
  },

  hide_spinner: function (section) {
    $( '#company_' + section + ' .loading_spinner').hide();
    $( '#company_' + section + ' .b-profile__submit').show();
  },

  show_success_message: function (section) {
    $( '#company_' + section + ' .error_message').hide();
    $( '#company_' + section + ' .success_message').show();
  },

  show_error_message: function (section) {
    $( '#company_' + section + ' .success_message').hide();
    $( '#company_' + section + ' .error_message').show();
  },

  hide_all_messages: function () {
    $( ' .success_message' ).hide();
    $( ' .error_message' ).hide();
  },

  init: function () {
    ProfilePage.gravatar_popup();
    ProfilePage.textarea_limitation();
    ProfilePage.spinner_init();
  }

}