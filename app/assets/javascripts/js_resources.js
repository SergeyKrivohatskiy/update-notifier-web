/**
 * Created with JetBrains RubyMine.
 * User: Dmitry
 * Date: 29.07.13
 * Time: 12:14
 * To change this template use File | Settings | File Templates.
 */

$(function() {
    $('#new-res-submit').click(function(){
        if ($('#title').val()==="") {
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

$(function() {
    $('#new-tag-submit').click(function(){
        if ($('#tag_name').val()==="") {
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

$(function() {
    var search_string = $('#tag_string').first();
    search_string.attr('title', 'Type here to find tag and press Enter');
    search_string.tooltip({ placement: 'right', trigger: 'manual' });
    search_string.tooltip('show');
    search_string.click(function () {
        $(this).tooltip('hide');
    });
});