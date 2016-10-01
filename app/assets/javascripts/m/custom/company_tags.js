var CompanyTags = window.CompanyTags = {

  init: function () {

    $(".tag_variants").each(function() {

      var input = $(this).parents('.tag_autocomplete_block').find('input[type="hidden"]');

      $(this).tagit({
        tagSource: function(search, showChoices) {

          var attrs = { q: search.term }
          var search_tag_mode = $( '#search_by_tags_mode' );
          if ( input.attr('id').indexOf("certification") >= 0 || search_tag_mode.length > 0 && search_tag_mode.val() == 'certificates' ) {
            attrs['certificates'] = true
          }

          var that = this;
          $.ajax({
            url: "/tags/autocomplete.json",
            data: attrs,
            success: function(choices) {
              showChoices(that._subtractArray(choices, that.assignedTags()));
            }
          });
        },
        // show_tag_url: "#{tags_path}/",
        singleField: true,
        singleFieldNode: input,
        allowSpaces: true
      });
      
    });
  }
}