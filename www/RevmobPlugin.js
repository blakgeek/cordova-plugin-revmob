var exec = require('cordova/exec');

function RevMob() {


    exec(dispatchEvent, null, "RevMobPlugin", "init");
    
    this.init = function (appId, successCallback, errorCallback) {

        exec(successCallback, errorCallback, "RevMobPlugin", "startSession", [appId]);
    };

    this.showInterstitialAd = function (successCallback, errorCallback) {
        exec(successCallback, errorCallback, "RevMobPlugin", "showInterstitialAd", []);
    };

    this.showBannerAd = function (showAtTop, claimSpace, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "RevMobPlugin", "showBannerAd", [
            showAtTop === true,
            claimSpace !== false
        ]);
    };

    this.hideBannerAd = function (releaseSpace, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "RevMobPlugin", "hideBannerAd", [releaseSpace !== false]);
    };

    this.claimBannerAdSpace = function (atTop) {
        exec(null, null, 'RevMobPlugin', 'claimBannerAdSpace', [atTop === true]);
    };

    this.releaseBannerAdSpace = function () {
        exec(null, null, 'RevMobPlugin', 'releaseBannerAdSpace', []);
    };

    this.openAdLink = function (successCallback, errorCallback) {
        exec(successCallback, errorCallback, "RevMobPlugin", "openAdLink", []);
    };

    this.showPopupAd = function (successCallback, errorCallback) {
        exec(successCallback, errorCallback, "RevMobPlugin", "showPopupAd", []);
    };

    this.enableTestMode = function (withAds) {
        exec(null, null, "RevMobPlugin", "enableTestMode", [withAds !== false]);
    };

    this.disableTestMode = function () {
        exec(null, null, "RevMobPlugin", "disableTestMode", []);
    };

    this.printEnvironmentInformation = function () {
        exec(null, null, "RevMobPlugin", "printEnvironmentInformation", []);
    };

    this.setConnectionTimeout = function (seconds) {
        exec(null, null, "RevMobPlugin", "setConnectionTimeout", [seconds]);
    };
    
    function dispatchEvent(e) {

        var event = new Event(e.type);
        if(e.data) {
            for (var prop in e.data) {

                event[prop] = e.data[prop];
            }
        }
        window.dispatchEvent(event);
    }
}

module.exports = RevMob;
// identify the plugin as being smoothie compatible
module.exports.$mixable = true;