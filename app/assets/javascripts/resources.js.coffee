# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new-res-submit').click ->
    if $('#title').val() == ""
      return false
    else
      $('#new-resource-form').submit()
    return true

$ ->
  $('#new-tag-submit').click ->
    if $('#tag_name').val() == ""
      return false
    else
      $('#new-tag-form').submit()
    return true

$ ->
  $('#form-search').submit ->
    input = $(this).find('input#tag_string')
    $('<input />').attr('type', 'hidden')
      .attr('name', 'tag_id')
      .attr('value', window.invert_tags[input.val()])
      .appendTo('#form-search')

#$ ->
#  id = setInterval(( ->
#    $.ajax('/update').done (data) ->
#      console.log(data)
#  ), 3000)

$ ->
  $('#unique').click ->
    $.ajax('/update').done (data) ->
      console.log(data)


#//$(function () {
#//    var search_string = $('#search_btn').first();
#//    search_string.attr('title', 'Type here to find tag');
#//    search_string.tooltip({ placement: 'right', trigger: 'manual' });
#//    search_string.tooltip('show');
#//    search_string.click(function () {
#//        $(this).tooltip('hide');
#//    });
#//});