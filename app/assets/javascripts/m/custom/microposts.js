var MicropostLength = window.MicropostLength = {

  init: function () {
    $(document).on('keyup', '.micropost_content', function () {
      var remaining = 140 - $(this).val().length;
      if (remaining >= 0)
        $(this).parents('form').find('.countdown').text(remaining + ' characters remaining');
      else {
        var max_text = $(this).val().substring(0,140);
        $(this).val(max_text);
        $(this).parents('form').find('.countdown').text('0 characters remaining');
      }
    });
  },

  pagination: function () {
    var $container = $('#b-feeds__container');
    
    $container.infinitescroll({
      navSelector  : '#page-nav',
      nextSelector : '#page-nav a',
      itemSelector : '.b-comment.post',
      loading: {
          finishedMsg: '',
          msgText: "<em class='glows_loading_spinner'>Loading ...</em>",
          img: '/images/spinner.gif',
        }
      },
      function( newElements ) {
        $('#b-feeds__container').append($(newElements));
      }
    );
  }
}
