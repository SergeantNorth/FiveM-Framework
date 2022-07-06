let player = undefined;

window.addEventListener('message', function(e) {
	$("#container").stop(false, true);
	if (e.data.transactionType == "playSound") {
		if (player != undefined) {
		  player.pause();
		}
		player = new Howl({src: ["./sounds/" + e.data.transactionFile + ".ogg"]});
		player.volume(e.data.transactionVolume);
		player.play();
	}
	
	if (e.data.displayWindow == 'true') {
        $("#container").css('display', 'flex');
  		
        $("#container").animate({
        	bottom: "25%",
        	opacity: "1.0"
        	},
        	700, function() {

        });

    } else {
    	$("#container").animate({
        	bottom: "-50%",
        	opacity: "0.0"
        	},
        	700, function() {
        		$("#container").css('display', 'none');
	         	
        });
    }
	

    


	

});

