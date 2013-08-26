/**
 * Created with JetBrains RubyMine.
 * User: Dmitry
 * Date: 29.07.13
 * Time: 12:14
 * To change this template use File | Settings | File Templates.
 */

$(function () {
    $('#new-res-submit').click(function () {
        if ($('#title').val() === "") {
            // invalid
            $('#title').next('.help-inline').show();
            return false;
        } else {
            // submit the form here
            // $('#InfroText').submit();
            $('#new-resource-form').submit();
            return true;
        }
    });
});

$(function () {
    $('#new-tag-submit').click(function () {
        if ($('#tag_name').val() === "") {
            // invalid
            $('#tag_name').next('.help-inline').show();
            return false;
        } else {
            // submit the form here
            // $('#InfroText').submit();
            $('#new-tag-form').submit();
            return true;
        }
    });
});

//$(function () {
//    $('#edit-res-submit').click(function () {
//        $('#edit-res-form').submit();
//    });
//});

//$(function () {
//    var search_string = $('#search_btn').first();
//    search_string.attr('title', 'Type here to find tag');
//    search_string.tooltip({ placement: 'right', trigger: 'manual' });
//    search_string.tooltip('show');
//    search_string.click(function () {
//        $(this).tooltip('hide');
//    });
//});

$(document).ready(function() {
    $('#form-search').submit(function() {
        var input = $(this).children('input');
        $('<input />').attr('type', 'hidden')
            .attr('name', 'tag_id')
            .attr('value', window.invert_tags[input.val()])
            .appendTo('#form-search');
        console.log('Hmm?')
    });
    console.log(window.invert_tags);
});

//$(function () {
//    $('[id^="edit-res-"]').each(function (i) {
//        $(this).click(function () {
//            var str = '' + i;
//            console.log(str);
//
//        })
//    })
//});