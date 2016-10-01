var ClickCheckbox = window.ClickCheckbox = {

  followed: function () {
    $(document).on('click', '.js-followed', function () {
      var checked = '';
      if ($('#checkbox1').is(':checked')){
        checked1 = 'checked';
      } else {
        checked1 = 'unchecked';
      }

      if ($('#checkbox2').is(':checked')){
        checked2 = 'checked';
      } else {
        checked2 = 'unchecked';
      }

      $('#b-feeds__container').infinitescroll('unbind');
      $.get("connections/follow", {checkbox1: checked1, checkbox2: checked2, page: 1});      
    });
  }
}
