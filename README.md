# RevMob Plugin For Cordova

This plugin was originally supposed to just wrap the [RevMob PhoneGap Cordova SDK](http://sdk.revmobmobileadnetwork.com/phonegap_cordova.html) to automate the manual installation steps.
But the banner support was lacking so I enhanced it.

## How do I install it? ##

* If you're like me and using [Cordova CLI](http://cordova.apache.org/):
```
cordova plugin add com.blakgeek.cordova.plugin.revmob
```

* If you're using [PhoneGap Buid](http://build.phonegap.com/):
```javascript
<gap:plugin name="com.blakgeek.cordova.plugin.revmob" source="plugins.cordova.io"/>
```

If you want to do it manually see the [RevMob docs](http://sdk.revmobmobileadnetwork.com/phonegap_cordova.html#configuration).

## How do I use it? ##
See the [RevMob documentation](http://sdk.revmobmobileadnetwork.com/phonegap_cordova.html#session).  Oh and remember you don't need to explicitly include the revmob.js file because the plugin handles that for you.

You can also take a look at the [demo project](https://github.com/blakgeek/cordova-plugin-revmob-demo).

TODO: add documentation

Enjoy!
