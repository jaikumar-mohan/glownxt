var CountriesAndStatesAutcomplete = window.CountriesAndStatesAutcomplete = {
 
  init: function () {
    CountriesAndStatesAutcomplete.coutry_autocomlete_init();
  },

  coutry_autocomlete_init: function () {

    $('#country_id').autocomplete({
      source: "/countries.json",
      focus: function( event, ui ) {
        $('#company_country_id').val( ui.item.id );
        return false;
      },
      select: function( event, ui ) {
        $('#company_country_id').val( ui.item.id );
        $('#country_id').val( ui.item.name );
        $('#state_id').val('');
        CountriesAndStatesAutcomplete.state_autocomplete_init();
        CountriesAndStatesAutcomplete.phone_autocomplete( ui.item.phone_prefix );

        return false;
      }
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
      return $( "<li>" )
      .append( "<a>" + item.name + "</a>" )
      .appendTo( ul );
    };

    if ( $('#company_country_id').val().length > 0 ) {
      CountriesAndStatesAutcomplete.state_autocomplete_init();
    }

    $(document).on('change keyup', '#country_id', function () {
      $('#state_id, #company_state_id').val('');
    });
    
    $(document).on('change blur', '#state_id', function () {
      if ( $(this).val().length < 1 ) {
        $('#company_state_id').val('');
      }
    }); 
  },

  state_autocomplete_init: function () {

    $('#state_id').autocomplete({
      source: "/countries/" + $('#company_country_id').val() +"/states.json",
      focus: function( event, ui ) {
        $('#company_state_id').val( ui.item.id );
        return false;
      },
      select: function( event, ui ) {
        $('#company_state_id').val( ui.item.id );
        $('#state_id').val( ui.item.name );

        return false;
      }
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
      return $( "<li>" )
      .append( "<a>" + item.name + "</a>" )
      .appendTo( ul );
    };

  },

  phone_autocomplete: function (phone_prefix) {
    $( '.company_tel_prefix' ).text(phone_prefix);
  }

}