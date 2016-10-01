var Messages = window.Messages = {

  recalculate_selected_companies: function () {
    var selected_company_ids = [];
    
    $( '.s-table__content tr.selected' ).each( function( key, value ) {
      selected_company_ids.push( $(value).attr('id').replace('company_', '') );
    });

    $( '#recepients' ).val(selected_company_ids);
  },

  table_selected_actions: function () {
    $(document).on('click', '.b-table__checkbox', function () {
      var parent = $(this).parents('tr');

      if (parent.hasClass('selected')) {

        parent.removeClass('selected');
        Messages.recalculate_selected_companies();
        $( '.group_message_error, .group_message_no_companies_error, .group_message_no_message_error' ).hide();

      } else {

        if ( $( '.s-table__content tr.selected' ).length > 4 ) {
          $( '.group_message_error' ).show();
        } else {
          parent.addClass('selected');
          Messages.recalculate_selected_companies();
          $( '.group_message_error, .group_message_no_companies_error, .group_message_no_message_error' ).hide();
        }

      }
    });
  },

  js_scroll_bar_init: function () {
    $('.scroll-pane').jScrollPane({ showArrows: true, mouseWheelSpeed: 50 });
    $('.jspPane').css('width', '925px');
  },

  auto_loading_companies_on_scroll_to_the_bottom: function () {
    $('.scroll-pane').bind(
      'jsp-arrow-change', function(event, isAtTop, isAtBottom, isAtLeft, isAtRight) {

      if ( isAtBottom ) {

        Messages.correct_browser_scroll_position();
        var next_page = $( '#next_page' ).val();

        if ( next_page > 0 ) {

          $( '.companies_loading_spinner' ).show();

          var attrs = { 
            by_name: $('#by_name').val(), 
            by_city: $('#by_city').val(), 
            by_country: $('#by_country').val(),
            page: $( '#next_page' ).val(),
            search_by_tags_mode: $('#search_by_tags_mode').val(),
            by_tags: $('#by_tags').val()
          }

          $.get("/messages/load", attrs);

        }

      }

    });
  },

  select_and_show: function (empty, add_class, micropost) {
    if( empty ) {
      $( '.group_message_success' ).hide();

      if ( add_class ) {
        $( '.group_message_no_message_error ').addClass('up_button');
      }

      $( '.group_message_no_message_error ').show();
    } else {
      $( '.group_message_error, .group_message_no_companies_error, .group_message_no_message_error' ).hide();
      $( '.s-table__content tr.selected' ).removeClass('selected');

      if ( add_class ) {
        $( '.group_message_success ').addClass('up_button');
      }

      $( '.group_message_success' ).show();
      setInterval(function() {
        $( '.group_message_success' ).hide();
      }, 4000);

      if ( micropost ) {
        $( '#micropost_content' ).val('');
        $('.countdown.share_glow_count').text('140 characters remaining');
      } else {
        $( '#micropost_content' ).val('');
        $('.countdown').text('140 characters remaining');
      }
    }

  },

  set_next_pagination_step: function ( next_step ) {
    $( '#next_page' ).val(next_step);
  },

  refreshNav: function() {
    var pane = $('.scroll-pane');
    var api = pane.data('jsp');
    api.reinitialise();
    Messages.correct_browser_scroll_position();
    $( '.companies_loading_spinner' ).hide();
    $('.jspPane').css('width', '925px');
  },

  correct_browser_scroll_position: function () {
    $('html, body').animate({
      scrollTop: $( '.s-table' ).offset().top - 90
    }, 500);
  },

  loading_spinner_init: function () {
    $(document).on('submit', '#new_micropost', function () {
      $(this).find('.s-btn').hide();
      $(this).find('.loading_spinner').show();
    });
  },

  search_tags_filter: function () {
    $(document).on('change', '#tags_search_mode', function () {
      $( '#search_by_tags_mode' ).val( $(this).val() );
      $(this).parents('.l-main').find('form.search_by_companies').submit();
    });
  },

  calculate_height_of_table: function ( count ) {
    if ( count == 1 ) {
      return '120px';
    } else if ( count == 2 ) {
      return '240px';
    } else if ( count == 3 ) {
      return '360px';
    } else {
      return '484px';
    }
  },

  correct_height_for_container: function ( count) {
    $( '.s-table__content.scroll-pane' ).css( 'height', Messages.calculate_height_of_table( count ) );
  },

  init: function () {
    Messages.table_selected_actions();
    Messages.js_scroll_bar_init();
    Messages.auto_loading_companies_on_scroll_to_the_bottom();
    Messages.loading_spinner_init();
    Messages.search_tags_filter();
  }
}