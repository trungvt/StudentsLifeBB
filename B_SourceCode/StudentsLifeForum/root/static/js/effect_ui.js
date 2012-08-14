var currentPic=1;

var tottalPics=3;

var keepTime;

function setupPicChange() { 
	keepTime=setTimeout("changePic()", 2000); 
}

function changePic() { 
	currentPic++; if(currentPic>tottalPics) currentPic=1;
	document.getElementById("banner_img").src="../static/images/banner"+currentPic+".jpg";
	setupPicChange(); 
}

function stopTimer() { 
	clearTimeout(keepTime);
}

function startTimer() { 
	keepTime=setTimeout("changePic()", 2000);
}

