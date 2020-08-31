function ShowAbout() {
	var scrW, scrH;
	if (window.innerHeight && window.scrollMaxY) {    // Mozilla   
		scrW = window.innerWidth + window.scrollMaxX;
		scrH = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight) {    // all but IE Mac    
		scrW = document.body.scrollWidth;
		scrH = document.body.scrollHeight;
	} else if (document.body) { // IE Mac    
		scrW = document.body.offsetWidth;
		scrH = document.body.offsetHeight;
	}

	var winW, winH;
	if (window.innerHeight) { // all except IE   
		winW = window.innerWidth;
		winH = window.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) {    // IE 6 Strict Mode    
		winW = document.documentElement.clientWidth;
		winH = document.documentElement.clientHeight;
	} else if (document.body) { // other    
		winW = document.body.clientWidth;
		winH = document.body.clientHeight;
	}  // for small pages with total size less then the viewport  

	var pageW = (scrW < winW) ? winW : scrW;
	var pageH = (scrH < winH) ? winH : scrH;

	var divheight = pageH; //document.body.offsetHeight;
	if (document.all) { //如果是IE浏览器则使用scrollTop属性
		document.getElementById("overlay").style.filter = "alpha(opacity=50)";
		document.getElementById("overlay").style.height = divheight;
		document.getElementById("lightbox").style.top = document.documentElement.scrollTop + 500;
	} else { //如果是NetScape浏览器则使用pageYOffset属性
		document.getElementById("overlay").style.opacity = "0.5";
		document.getElementById("overlay").style.height = divheight + "px";
		document.getElementById("lightbox").style.top = window.pageYOffset + 500 + "px";
	}
	document.getElementById("overlay").style.display = "block";
	document.getElementById("lightbox").style.display = "block";
}

function ShowOK() {
	document.getElementById("overlay").style.display = "none";
	document.getElementById("lightbox").style.display = "none";
	if (document.title.indexOf("Yu Liu") != -1) {
		self.location = "index_cn.htm";
	} else {
		self.location = "index.htm";
	}
}

function ShowCancel() {
	document.getElementById("overlay").style.display = "none";
	document.getElementById("lightbox").style.display = "none";
}