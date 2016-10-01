window.Glowfori =
  init: ->
    $('.s-label').labels()
    $(document)
      .on 'click', '.js-navigation-toggle-account', (event)->
        $target = $ event.currentTarget
        $target.closest('.b-navigation__item-right').toggleClass 'active'

      .on 'click', '.js-comments-create-link', (event)->
        event.preventDefault()
        $parent = $(event.currentTarget).closest('.b-comments__item')
        $parent.find('.js-comments-form').toggleClass 'hidden'

$ ->
  Glowfori.init()
