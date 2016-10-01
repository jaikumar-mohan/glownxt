var FormChange = window.FormChange = {

  ret: false,
  showalert: true,
  off_page_link: '',

  init: function () {
  	var form = $('form').watchChanges();
 
    $(document).on('click', 'a.b-sidebar-menu__link', function () {
      var link = $(this);

  	  if(form.hasChanged()) {
        var current_link = $('a.b-sidebar-menu__link.current');
        FormChange.fancyConfirm(function(ret) {
          if (FormChange.ret) {
            FormChange.reset_form(current_link);
            FormChange.switch_tab(link);
          }
        });
  	  } else {
        FormChange.switch_tab(link);
      }

      return false;
    });  

    $(document).on('click', 'a.js-off_page_link', function () {
      FormChange.off_page_link = this.href;
      if(form.hasChanged()) {
        FormChange.fancyConfirm(function(ret) {
          if (FormChange.ret) {
            window.location.href = FormChange.off_page_link;
          }
        });
      } else {
        window.location.href = FormChange.off_page_link;
      }

      return false;
    });    

    $(document).on('mousedown', 'a.js-off_page_link[href]', FormChange.offBeforeUnload).on('mouseleave', 'a.js-off_page_link[href]', function () {
      $(window).on('beforeunload', FormChange.windowBeforeUnload);
    });

    $(window).on('beforeunload', FormChange.windowBeforeUnload);

    $(document).on('click', '#fancyConfirm_cancel', function () {
      $(window).on('beforeunload', function(){
        return 'Changes are not saved and will be lost!';
      });
    });

    $(document).on('submit', '#company_marketing form', function () {
      $(".tag_variants").each(function( index, element) {
        FormChange.update_tags_default_values(element);
      });
    });
  },

  offBeforeUnload: function (event) {
    $(window).off('beforeunload');
  },

  windowBeforeUnload: function () {
    // do nothing
  },

  reset_form: function (link) {
    var form_id = link.attr('data-content');
    var changed_form = $('#' + form_id + ' form');

    changed_form.reset_form();
    if ( form_id == 'company_marketing' ) {
      $(".tag_variants").each(function( index, element) {
        FormChange.reset_tag_block(element);
      });

      CompanyTags.init();
    }
  },

  reset_tag_block: function (element) {
    var tags_block_id = $(element).attr('id');
    var initial_values = $( '#' + tags_block_id.replace('_list', '_default_list') ).val();
    var parent_js_block = $(element).parents('.js-edit_tags_container');

    $(element).parents('.tag_autocomplete_block').find('.hidden_tags_input').val(initial_values);
    $(element).remove();
    var new_tags_block_html = '<ul class="tag_variants" id="' + tags_block_id + '_list"></ul>';
    parent_js_block.html(new_tags_block_html);
  },

  update_tags_default_values: function (element) {
    var tags_block_id = $(element).attr('id');
    var default_values_input = $( '#' + tags_block_id.replace('_list', '_default_list') );
    var current_values_input = $(element).parents('.tag_autocomplete_block').find('.hidden_tags_input');
    default_values_input.val(current_values_input.val());
  },

  switch_tab: function (link) {
    $( '.b-profile__content' ).hide();
    $( '.b-profile__content#' + link.attr('data-content') ).show();
    $( '.b-sidebar-menu__link' ).removeClass('current');
    link.addClass('current');
  },

  save_changes: function() {
  	$('form').watchChanges();
  },
 	
  head_foot_links: function(){
  	$("form").each(function () {
      var originals = '';
      var form = $(this);

      function extractFormData() {
        var formdata = form.serialize();
        form.find('input[type=file]').each(function () {
            formdata = formdata + $(this).val();
        });
        return formdata;
      }
    
      function saveOriginals(form) {
      originals  = extractFormData();
	  }

	  function allowSave() {
	    FormChange.showalert = false;
	  }

	  $(window).bind('beforeunload', function() {
	    var current = extractFormData();
	    if (current !== originals && FormChange.showalert === true) {
        return false;
	    }
	  });

    $(document).ready(saveOriginals);
      form.submit(allowSave);
    });
  },

  fancyConfirm: function(callback) {
    var ret;

    $.fancybox({
        modal : true,
        content : $('.are_your_sure_modal_container').html(),
        afterLoad : function() {
          $(document).on('click', "#fancyConfirm_cancel", function () {
            FormChange.ret = false; 
            $.fancybox.close();
          })

          $(document).on('click', "#fancyConfirm_ok", function () {
            FormChange.ret = true; 
            $.fancybox.close();
          })
        },
        afterClose : function() {
          callback.call(this,FormChange.ret);
        }
    });
  }  
}