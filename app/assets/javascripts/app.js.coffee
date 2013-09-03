window.fadeIn = ->
  $('body').append('<div class="my-modal-backdrop"></div> ')

window.fadeOut = ->
  $('.my-modal-backdrop').remove()