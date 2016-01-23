"use strict";

function OpenTestingUI() {
	$('#TestingUIWindow').ToggleClass('hidden');
}

function DisplayInfoButton() {

}

function SpawnFireBoss() {
	$.Msg("TEST");
	GameEvents.SendCustomGameEventToServer("spawn_fire_boss", {
	});
}

function SpawnWaterBoss() {
	$.Msg("TESTTWO");
}