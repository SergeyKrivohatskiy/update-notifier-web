function getName(callback) {
    gapi.client.load('plus', 'v1', function() {
        gapi.client.plus.people.get( {'userId' : 'me'} ).execute(function(resp) {
            callback([resp.name.givenName, resp.name.familyName]);
        })
    });
}
// Don't call signinCallback from the G+ button!
function signinCallback2(authResult) {
    if (authResult['access_token']) {
        document.getElementById('signinButton').setAttribute('style', 'display: none');
        gapi.auth.setToken(authResult);
        gapi.client.load('oauth2', 'v2', function() {
            gapi.client.oauth2.userinfo.get().execute(function(resp) {
                getName(function(result_array) {
                var array = result_array;
                $('<form action="signin" method="POST">' +
                    '<input type="hidden" name="email" value="' + resp.email + '">' +
                    '<input type="hidden" name="name" value="' + array[0] + '">' +
                    '<input type="hidden" name="surname" value="' + array[1] + '">' +
                    '</form>').submit();
                });

            })
        });
    } else if (authResult['error']) {
//    document.getElementById('res').setAttribute('style', 'display: none')
        // There was an error.
        // Possible error codes:
        //   "access_denied" - User denied access to your app
        //   "immediate_failed" - Could not automatically log in the user
        // console.log('There was an error: ' + authResult['error']);
    }
}