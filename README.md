# RevMob Plugin For Cordova
Adds support for RevMob Ads to your Cordova and Phonegap based mobile apps.
I created this because the official Phonegap/Cordova SDK from RevMob is let's say lacking and requires too many manual steps.

## How do I install it? ##

If you're like me and using [Cordova CLI](http://cordova.apache.org/):
```
cordova plugin add cordova-plugin-revmob
```

or

```
phonegap local plugin add cordova-plugin-revmob
```

TODO: add manual installation steps

## WARNING: iOS Cordova Registry
****Installing this plugin directly from Cordova Registry results in Xcode using a broken `RevMobAds.framework`, this is because the current publish procedure to NPM breaks symlinks [CB-6092](https://issues.apache.org/jira/browse/CB-6092). Please install the plugin through through the github url or re-add the `RevMobAds.framework` manually.****


## How do I use it? ##

```javascript
document.addEventListener('deviceready', function() {

	window.revmob = new RevMob();

	// get things started by passing in your app id
	revmob.init('<your app id>', function() {
		console.log('super dope it worked');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show a banner at the top the screen and resize the webview to make space for it
	revmob.showBannerAd(true, true, function() {
		console.log('oh snap I got a banner at the top');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show a banner at the bottom of the screen and overlay the webview.  overlaying is useful if the space the banner has already been accounted for
	revmob.showBannerAd(false, false, function() {
		console.log('what what see the banner at the bottom');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// hide the banner but the keep the where it was occupied
	revmob.hideBannerAd(false, function() {
		console.log('now you see me now you do not');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// hide the banner and release the space that it occupied
	revmob.hideBannerAd(true, function() {
		console.log('now you see me now you do not');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// make space at the top of the screen for a banner that will be displayed later
	// this will resize the webview
    revmob.claimBannerAdSpace(true);

	// make space at the bottom of the screen for a banenr that will be displayed later.
	// if not argument is passed it will default to making the space at the bottom
	revmob.claimBannerAdSpace(false);

    // release the space occupied the banner
    revmob.releaseBannerAdSpace();

	// show an interstitial
	revmob.showInterstitialAd(function() {
		console.log('now that is a big ole interstitial');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show a popup ad
	revmob.showPopupAd(function() {
		console.log('pop!');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// open an ad link (useful if want to tightly integrate ads into your UI)
	revmob.openAdLink(function() {
		console.log('we ya link bredren');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// enable test mode with ads (defaults to true if no argument is passed)
	revmob.enableTestMode(true);

	// enable test mode without ads
	revmob.enableTestMode(false);

	// enable test mode without ads
	revmob.disableTestMode();

	// change the time to wait for an add to be served (value is in seconds)
	revmob.setConnectionTimeout(90);

	// spit out a bunch data about the environment
	revmob.printEnvironmentInformation();

}, false);
```

For a full working example see the [demo project](https://github.com/blakgeek/cordova-plugin-revmob-demo).

Enjoy!
