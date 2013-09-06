# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.tagData = ->
  tag: { name: $('#tag_name').val() }

window.resourceData = ->
  resource: {
    name: $('#resource_name').val(),
    url: $('#resource_url').val(),
    tags: $('#resource_tags').val(),
    filter: $('#resource_filter').val(),
    schedule_code: $('#resource_schedule_code').val()
  }

window.resourceData2 = ->
  resource: {
    name: $('#resource2_name').val(),
    url: $('#resource2_url').val(),
    tags: $('#resource2_tags').val(),
    filter: $('#resource2_filter').val(),
    schedule_code: $('#resource2_schedule_code').val()
  }

window.errorMessageConstructor = (response) ->
  htmlErr = '<div class="alert alert-error breakable"><ul>'
  $.each(response.responseJSON, (index, value) ->
    htmlErr += '<li>'
    htmlErr += value
    htmlErr += '</li>'
  )
  htmlErr += '</ul></div>'
  return htmlErr;

window.formSubmit = (sbmtBtnId, modalWinId, formId, dataHashFnc) ->
  $(sbmtBtnId).click ->
    modalWin = $(modalWinId)
    form = $(formId)
    fadeIn()
    $.post(
      form.attr('action'), dataHashFnc()
    ).done( ->
      fadeOut()
      modalWin.modal('hide')
      form[0].reset()
      modalWin.find('.errors').html('')
    ).fail((response) ->
      fadeOut()
      htmlErr = errorMessageConstructor(response);
      modalWin.find('.errors').html(htmlErr)
    )

$ ->
  $('.modal-close').each(->
    $(this).click(->
      parentWin = $(this).parents('.modal-win')
      parentWin.modal('hide')
      parentWin.find('.modal-form')[0].reset()
      parentWin.find('.errors').html('')
    )
  )

$ ->
  formSubmit('#new-res-submit','#new-res-modal','#new-res-form', resourceData)

$ ->
  formSubmit('#new-tag-submit','#new-tag-modal','#new-tag-form', tagData)

window.submitEdition = ->
  $('#edit-res-submit').click ->
    modalWin = $('#edit-res-form')
    fadeIn()
    $.ajax(
      modalWin.find('form').attr('action'),
      {
        type: 'PUT',
        data: resourceData2()
      }
    ).done( ->
      fadeOut()
      modalWin.modal('hide')
      modalWin.find('.errors').html('')
    ).fail((response) ->
      fadeOut()
      htmlErr = errorMessageConstructor(response);
      modalWin.find('.errors').html(htmlErr)
    )


window.tagSearchSubmit = ->
  input = $('#form-search').find('input#tag_string')
  value = window.invert_tags[input.val()]
  if typeof value == 'undefined'
    return false
  path = $('#form-search').attr('action')
  tag_id='?tag_id='+value
  fadeIn()
  $.get(path+tag_id).always(fadeOut())
  return false

$ ->
  id = setInterval(( ->
    $.ajax('/update').done (data) ->
      $.each(data, (index, value) ->
        elem = $('#row-' + value).first()
        elem.tooltip({ placement: 'left', trigger: 'manual', title: 'This resource has been updated' })
        elem.tooltip('show')
        #        elem.addClass('update-exists')
        elem.click ->
          $(this).tooltip('hide')
#          $(this).removeClass('update-exists')
      )
  ), 13000)

#$ ->
#  $('#unique').click ->
#    $.ajax('/update').done (data) ->
#      $.each(data, (index, value) ->
#        elem = $('#row-'+value).first()
#        elem.tooltip({ placement: 'left', trigger: 'manual', title: 'This resource has been updated' })
#        elem.tooltip('show')
#        #        elem.addClass('update-exists')
#        elem.click ->
#          $(this).tooltip('hide')
##          $(this).removeClass('update-exists')
#      )

#//$(function () {
#//    var search_string = $('#search_btn').first();
#//    search_string.attr('title', 'Type here to find tag');
#//    search_string.tooltip({ placement: 'right', trigger: 'manual' });
#//    search_string.tooltip('show');
#//    search_string.click(function () {
#//        $(this).tooltip('hide');
#//    });
#//});