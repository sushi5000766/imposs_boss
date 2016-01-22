"use strict";



var mode = 1;
var camDist;

function OnButtonPressed( data ) {
	var iPlayerID = Players.GetLocalPlayer();
	if (mode == 0){
		GameUI.SetCameraLookAtPositionHeightOffset( 0 );
		$("#Label").text = "Camera Lock Near";
		mode = 1
	}
	else if (mode == 1){
		GameUI.SetCameraLookAtPositionHeightOffset( 250 );
		$("#Label").text = "Camera Lock Medium";
		mode = 2
	}
	else if (mode == 2){
		GameUI.SetCameraLookAtPositionHeightOffset( 420 );
		$("#Label").text = "Camera Lock Far";
		mode = 0
	}
}