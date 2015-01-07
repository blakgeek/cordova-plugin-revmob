function RevMob(globalAppId) {

	this.startSession = function(appId, successCallback, errorCallback) {
		appId = appId || globalAppId;
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
	};

	this.showFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showFullscreen", []);
	};

	this.openAdLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openAdLink", []);
	};

	this.showPopup = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showPopup", []);
	};

	this.showBanner = function(showAtTop, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showBanner", [showAtTop === true]);
	};

	this.hideBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideBanner", []);
	};

	this.setTestingMode = function(testingMode) {
		cordova.exec(null, null, "RevMobPlugin", "setTestingMode", [testingMode]);
	};

	this.printEnvironmentInformation = function() {
		cordova.exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
	};

	this.setTimeoutInSeconds = function(seconds) {
		cordova.exec(null, null, "RevMobPlugin", "setTimeoutInSeconds", [seconds]);
	};

	// alias functions so the common plugin can ultimately work with smoothie
	this.init = this.startSession;
	this.showBannerAd = this.showBanner;
	this.hideBannerAd = this.hideBanner;
	this.showInterstitialAd = this.showFullscreen;
}

if(typeof module != 'undefined' && module.exports) {
	module.exports = RevMob;
	// identify the plugin as being smoothie compatible
	module.exports.$mixable = true;
}