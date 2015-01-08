function RevMob() {

	this.init = function(appId, successCallback, errorCallback) {

		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
	};

	this.showInterstitialAd = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showInterstitialAd", []);
	};

	this.showBannerAd = function(showAtTop, claimSpace, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showBannerAd", [
			showAtTop === true,
			claimSpace !== false
		]);
	};

	this.hideBannerAd = function(releaseSpace, successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideBannerAd", [releaseSpace !== false]);
	};

	this.claimBannerAdSpace = function(atTop) {
		cordova.exec(null, null, 'RevMobPlugin', 'claimBannerAdSpace', [atTop === true]);
	};

	this.releaseBannerAdSpace = function(atTop) {
		cordova.exec(null, null, 'RevMobPlugin', 'releaseBannerAdSpace', []);
	};

	this.openAdLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openAdLink", []);
	};

	this.showPopupAd = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showPopupAd", []);
	};

	this.enableTestMode = function(withAds) {
		cordova.exec(null, null, "RevMobPlugin", "enableTestMode", [withAds === false]);
	};

	this.disableTestMode = function() {
		cordova.exec(null, null, "RevMobPlugin", "disableTestMode", []);
	};

	this.printEnvironmentInformation = function() {
		cordova.exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
	};

	this.setConnectionTimeout = function(seconds) {
		cordova.exec(null, null, "RevMobPlugin", "setConnectionTimeout", [seconds]);
	};
}

if(typeof module != 'undefined' && module.exports) {
	module.exports = RevMob;
	// identify the plugin as being smoothie compatible
	module.exports.$mixable = true;
}