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