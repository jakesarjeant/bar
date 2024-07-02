function init() {
	// idk init stuff
}

App.config({
	onConfigParsed: () => {
		init();
	},

	windows: () => [
		...forMonitors(Bar),
		// ...forMonitors(NotificationPopups),
		// ...forMonitors(ScreenCorners),
		// ...forMonitors(OSD),
		//Launcher(),
		//Overview(),
		//PowerMenu(),
		//SettingsDialog(),
		//Verification(),
	],
});
