var Glows = window.Glows = {

  init: function () {
    $(document).on('ajax:complete', '#new_message', function () {
      $(this).find('textarea').val('');
    });

    $(document).on('click', '.js-comments-destroy-link', function () {
      if( $(this).parents('ul.comment').find('li').length < 2)
      {
        $(this).parents('.post').find('.js-comments-collapse-link').hide();
      }
      $(this).parents('.remove_micropost_form').submit();
      $(this).closest('.b-comments__item').remove();
      return false;
    });
  }
}