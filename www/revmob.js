
function RevMob(appId) {
	this.appId = appId;
	this.TEST_DISABLED = 0;
	this.TEST_WITH_ADS = 1;
	this.TEST_WITHOUT_ADS = 2;

	this.startSession = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
	}

	this.showFullscreen = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showFullscreen", []);
	}

	this.openAdLink = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "openAdLink", []);
	}

	this.showPopup = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showPopup", []);
	}

	this.showBanner = function(showAtTop, successCallback, errorCallback) {
		if(showAtTop === true) {
			showAtTop = 'YES';
		} else {
			showAtTop = 'NO';
		}
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "showBanner", [showAtTop]);
	}

	this.hideBanner = function(successCallback, errorCallback) {
		cordova.exec(successCallback, errorCallback, "RevMobPlugin", "hideBanner", []);
	}

	this.setTestingMode = function(testingMode) {
		cordova.exec(null, null, "RevMobPlugin", "setTestingMode", [testingMode]);
	}

	this.printEnvironmentInformation = function() {
		cordova.exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
	}

	this.setTimeoutInSeconds = function(seconds) {
		cordova.exec(null, null, "RevMobPlugin", "setTimeoutInSeconds", [seconds]);
	}
}

if (typeof module != 'undefined' && module.exports) {
  module.exports = RevMob;
}