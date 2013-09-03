# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new-res-submit').click ->
    $.post(
      window.location.href,
      {
        resource: {
          name: $('#resource_name').val(),
          url: $('#resource_url').val(),
          tags: $('#resource_tags').val(),
          filter: $('#resource_filter').val(),
          schedule_code: $('#resource_schedule_code').val()
        }
      }
    ).done( ->
      $('#new-res-form').modal('hide')
      $('#new-res-form').find('form')[0].reset()
      $('#new-res-form').find('.errors').html('')
    ).fail((response) ->
      html_errors = '<div class="alert alert-error"><ul>'
      $.each(response.responseJSON, (index, value) ->
        html_errors+='<li>'
        html_errors+=value
        html_errors+='</li>'
      )
      html_errors+='</ul></div>'
      $('#new-res-form').find('.errors').html(html_errors)
    )

window.submitEdition = ->
  $('#edit-res-submit').click ->
    my_modal = $('#edit-res-form')
    link = my_modal.find('form').attr('action')
    $.ajax(
      link,
      {
        type: 'PUT',
        data: {
          resource: {
            name: $('#resource2_name').val(),
            url: $('#resource2_url').val(),
            tags: $('#resource2_tags').val(),
            filter: $('#resource2_filter').val(),
            schedule_code: $('#resource2_schedule_code').val()
          }
        }
      }
    ).done( ->
      my_modal.modal('hide')
      my_modal.find('.errors').html('')
    ).fail((response) ->
      html_errors = '<div class="alert alert-error"><ul>'
      $.each(response.responseJSON, (index, value) ->
        html_errors+='<li>'
        html_errors+=value
        html_errors+='</li>'
      )
      html_errors+='</ul></div>'
      my_modal.find('.errors').html(html_errors)
    )


$ ->
  $('#new-tag-submit').click ->
    $('#new-tag-form').submit()

$ ->
  $('#form-search').submit ->
    input = $(this).find('input#tag_string')
    value = window.invert_tags[input.val()]
    if typeof value == 'undefined'
      return false
    $('<input />').attr('type', 'hidden')
      .attr('name', 'tag_id')
      .attr('value', value)
      .appendTo('#form-search')

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