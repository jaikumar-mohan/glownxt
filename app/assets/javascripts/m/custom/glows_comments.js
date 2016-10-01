var GlowComments = window.GlowComments = {

  init: function () {
    $(document).on('click', '.js-comments-create-link', function () {
      $('.js-comments-form').hide();
      var new_comment_block = $(this).parents('.b-comments__item').find('.js-comments-form');
      new_comment_block.show();
      new_comment_block.find('input').focus();
      
      return false;
    });

    $(document).on('ajax:complete', '.js-comments-form', function () {
      $(this).find('input').val('');
    });

    $(document).on('click', '.js-comments-collapse-link', function () {
      var comments_list = $(this).parents('.post').find('.b-comments__list');

      if ( comments_list.hasClass('hidden') ) {
        $(this).text('collapse');
        comments_list.removeClass('hidden');
      } else {
        $(this).text('expand');
        comments_list.addClass('hidden');
      }
      
      return false;
    });
  }
}
