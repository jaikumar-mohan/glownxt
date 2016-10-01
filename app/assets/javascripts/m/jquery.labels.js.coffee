(($)->
  $.fn.labels = ( ->
    @.each( ->
      $this = $ @
      padding = 7
      styles = $this.find('.s-label__value').css(['right', 'paddingLeft', 'paddingRight', 'width'])
      if styles?
        $.each styles, (prop, value)->
           padding += parseInt value
      else
        padding += 12
      $this.css 'paddingRight', padding
    )
  )
)(jQuery)