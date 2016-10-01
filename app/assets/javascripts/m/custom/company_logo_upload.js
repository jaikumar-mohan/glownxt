var CompanyLogoUpload = window.CompanyLogoUpload = {

  file_upload_init: function () {

    $('.file-field-container').fileupload({
      dataType: "script",
      add: function(e, data) {

        $('.upload_error_message' ).
          addClass('hidden').text("");

        var file = data.files[0];
        var filename = file.name;
        var valid_extensions = ['jpg', 'jpeg', 'png', 'gif'];
        var file_ext = filename.substr(filename.lastIndexOf('.') + 1).toLowerCase();

        if ($.inArray(file_ext, valid_extensions) == -1 || (file.size > 2000000) ){
          $(this).find('.upload_error_message' ).
            removeClass('hidden').
            text("File must be JPG, JPEG, GIF or PNG, less than 2MB");
          return false;
        } else {
          data.context = $(tmpl("template-upload", file));
          $('.file-field-container .company-progress-bar-container').html(data.context);
          $('.file-field-container .company-progress-bar-container .bar').css('width', '10%');
          return data.submit();
        }
      },
      progress: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('.file-field-container .company-progress-bar-container .bar').css(
            'width',
            progress + '%'
        );
      },
      success: function (e, data) {
        $('.file-field-container .company-progress-bar-container .bar').css('width', '100%');
      }
    }).bind("fileuploaddone", function (e, data) {
      $('.file-field-container .company-progress-bar-container .bar').css('width', '100%');
      $('.file-field-container .company-progress-bar-container').empty();
    });
  },

  browse_button_init: function () {
    $(document).on('click', '.js-file-emulator', function () {
      $(this).parents('form').find('input[type="file"]').click();

      return false;
    });
  },

  init: function () {
    CompanyLogoUpload.browse_button_init();
    CompanyLogoUpload.file_upload_init();
  }
};