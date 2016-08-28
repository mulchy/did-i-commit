$(document).ready(function() {
  
  var lock = new Auth0Lock(AUTH0_CLIENT_ID, AUTH0_DOMAIN, {
    auth: {
      params: { scope: 'openid email' }
    }
  });

  $('.btn-login').click(function(e) {
    e.preventDefault();
    lock.show();
  });

  $('.btn-logout').click(function(e) {
    e.preventDefault();
    logout();
  })

  lock.on("authenticated", function(authResult) {
      console.log(authResult);
      lock.getProfile(authResult.idToken, function(error, profile) {
      if (error) {
          console.log('error logging in');
        return;
      }
	  localStorage.setItem('id_token', authResult.idToken);
	  localStorage.setItem('access_token', authResult.accessToken);
	  localStorage.setItem('nickname', profile.nickname);
	// Display user information
      show_profile_info(profile);
      });
  });

    $.ajaxSetup({
	'beforeSend': function(xhr) {
	    if (localStorage.getItem('id_token')) {
		xhr.setRequestHeader('Authorization',
				     // why not Bearer like the rest of the world
				     'token ' + localStorage.getItem('access_token'));
	    }
	}
    });
    
  //retrieve the profile:
  var retrieve_profile = function() {
    var id_token = localStorage.getItem('id_token');
    if (id_token) {
      lock.getProfile(id_token, function (err, profile) {
        if (err) {
          return alert('There was an error getting the profile: ' + err.message);
        }
        // Display user information
        show_profile_info(profile);
      });
    }
  };

    var show_profile_info = function(profile) {
	console.log(profile);
     $('.nickname').text(profile.nickname);
     $('.btn-login').hide();
     $('.avatar').attr('src', profile.picture).show();
     $('.btn-logout').show();
  };

  var logout = function() {
      localStorage.removeItem('id_token');
      localStorage.removeItem('access_token');
      localStorage.removeItem('nickname');
    window.location.href = "/";
  };

    retrieve_profile();

    var get_username = function() {
	var nickname = localStorage.getItem('nickname');
	if (!nickname) {
	    throw 'unknown username';
	}
	return nickname;
    }
    
    var get_public_notifications = function() {
	$.get({
	    url: 'https://api.github.com/users/' + get_username() + '/events/public'
	}).then(function(response) {
	    console.log(response);
	});
    };

    $('#button').on('click', get_public_notifications);
});
