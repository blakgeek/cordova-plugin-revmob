# RevMob Plugin For Cordova
Adds support for RevMob Ads to your Cordova and Phonegap based mobile apps.
I created this because the official Phonegap/Cordova SDK from RevMob is let's say lacking and requires too many manual steps.

## How do I install it? ##

If you're like me and using [Cordova CLI](http://cordova.apache.org/):
```
cordova plugin add https://github.com/blakgeek/cordova-plugin-revmob
```

or

```
phonegap local plugin add https://github.com/blakgeek/cordova-plugin-revmob
```

TODO: add manual installation steps

## WARNING: iOS Cordova Registry
****Installing this plugin directly from Cordova Registry results in Xcode using a broken `RevMobAds.framework`, this is because the current publish procedure to NPM breaks symlinks [CB-6092](https://issues.apache.org/jira/browse/CB-6092). Please install the plugin through through the github url or re-add the `RevMobAds.framework` manually.****


## How do I use it? ##

```javascript
document.addEventListener('deviceready', function() {

	window.revmob = new RevMob();

	// get things started by passing in you app id
	revmob.init('<you app id>', function() {
		console.log('super dope it worked');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show a banner at the top the screen (if no arguments is passed it will default showing at the bottom)
	revmob.showBannerAd(true, function() {
		console.log('oh snap I got a banner at the bottom');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show a banner at the bottom of the screen
	revmob.showBannerAd(false, function() {
		console.log('what what see the banner at the bottom');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// hide the banner
	revmob.hideBannerAd(function() {
		console.log('now you see me now you do not');
	}, function(err) {
		console.error(['oh crap', err]);
	});

	// show and interstitial
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
