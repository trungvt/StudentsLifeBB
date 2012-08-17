function register_formValidation() {
	var username = document.registration.username;
	var password = document.registration.password;
	var confirm = document.registration.confirm;
	var email = document.registration.email;
	
	// Check username
	if (username_validation(username,5,12) && allLetter_validation(username)) {
		// Check password
		if (password_validation(password,5,20)) {
			// Check confirm
			if (confirm_validation(password, confirm)) {
				// Check email
				if (email_validation(email)) {
					return true;
				}
			}
		}
	}
	return false;
}

function username_validation(username,mx,my) {
	var uid_len = username.value.length;
	if (uid_len == 0 || uid_len >= my || uid_len < mx) {
		alert("User name should not be empty / length be between "+mx+" to "+my);
		username.focus();
		return false;
	}
	return true;
}

function allLetter_validation(uname) { 
	var letters = /^[A-Za-z]+$/;
	if(uname.value.match(letters)) {
		return true;
	} else {
		alert('Username must have alphabet characters only');
		uname.focus();
		return false;
	}
}

function password_validation(password,mx,my) {
	var passid_len = password.value.length;
	if (passid_len == 0 || passid_len >= my || passid_len < mx) {
		alert("Password should not be empty / length be between "+mx+" to "+my);
		password.focus();
		return false;
	}
	return true;
}

function confirm_validation(password, confirm) {
	if (password.value != confirm.value) {
		alert("Password confirm not matched!");
		confirm.focus();
		return false;
	}
	return true;
}

function email_validation(uemail) {
	var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	if(uemail.value.match(mailformat)) {
		return true;
	} else {
		alert("You have entered an invalid email address!");
		return false;
	}
} 
