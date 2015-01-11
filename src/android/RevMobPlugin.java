package com.blakgeek.cordova.plugin.revmob;


import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import com.revmob.RevMob;
import com.revmob.RevMobAdsListener;
import com.revmob.RevMobTestingMode;
import com.revmob.ads.banner.RevMobBanner;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

public class RevMobPlugin extends CordovaPlugin {

    private static final String LOGTAG = "[RevMobPlugin]";
    private float scale;
    private RevMob revmob;
    private RevMobBanner banner;
    private ViewGroup bannerWrapper;
    private CallbackEnableRevMobAdListener bannerAdListener;
    private SessionRevMobAdListener sessionAdListener;
    private RevMobTestingMode testMode = RevMobTestingMode.DISABLED;
    private int connectionTimeout = 30; // default value from RevMobClient.java
    private boolean bannerAtTop = true;
    private ViewGroup blender;
    private ViewGroup webViewContainer;

    @Override
    protected void pluginInitialize() {
        super.pluginInitialize();

        scale = cordova.getActivity().getResources().getDisplayMetrics().density;
        bannerAdListener = new CallbackEnableRevMobAdListener();
        banner = new RevMobBanner(cordova.getActivity(), bannerAdListener);

        // look for the smoothie parent view
        webViewContainer = (ViewGroup) webView.getParent();

        // create banner view
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {

                plugInBlender();
                // TODO: deal with scaling banner for tablets
                bannerWrapper = new RelativeLayout(cordova.getActivity());
                bannerWrapper.setLayoutParams(new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

                // set the size to the defaults so the banner can be centered
                RelativeLayout.LayoutParams bannerLayout = new RelativeLayout.LayoutParams(dips(RevMobBanner.DEFAULT_WIDTH_IN_DIP), dips(RevMobBanner.DEFAULT_HEIGHT_IN_DIP));
                bannerLayout.addRule(RelativeLayout.CENTER_HORIZONTAL);
                banner.setLayoutParams(bannerLayout);

                // add the ingredient to the cup
                bannerWrapper.addView(banner);
                blender.addView(bannerWrapper);
            }
        });
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if ("showBannerAd".equals(action)) {

            showBannerAd(args, callbackContext);
        } else if ("hideBannerAd".equals(action)) {

            hideBannerAd(args, callbackContext);
        } else if ("startSession".equals(action)) {

            initializeRevMob(args, callbackContext);
        } else if ("openAdLink".equals(action)) {

            openAdLink(callbackContext);
        } else if ("showPopupAd".equals(action)) {

            showPopupAd(callbackContext);
        } else if ("showInterstitialAd".equals(action)) {

            showInterstialAd(callbackContext);
        } else if ("printEnvironmentInformation".equals(action)) {

            printEnvironmentInformation(callbackContext);
        } else if ("setConnectionTimeout".equals(action)) {

            setConnectionTimeout(args, callbackContext);
        } else if ("enableTestMode".equals(action)) {

            enableTestMode(args, callbackContext);
        } else if ("disableTestMode".equals(action)) {

            disableTestMode(callbackContext);
        } else if ("claimBannerAdSpace".equals(action)) {

            // TODO: implement code to claim space

        } else if ("releaseBannerAdSpace".equals(action)) {

            // TODO: implement code to release space

        } else {

            return false;
        }

        return true;
    }

    private void showBannerAd(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final boolean showAtTop = args.getBoolean(0);
        // TODO: figure out how to not
        final boolean claimAdSpace = args.getBoolean(1);


        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (showAtTop != bannerAtTop) {
                    bannerAtTop = showAtTop;
                    webViewContainer.removeView(blender);
                    webViewContainer.addView(blender, bannerAtTop ? 0 : webViewContainer.indexOfChild(webView) + 1);
                }

                blender.setVisibility(View.VISIBLE);
            }
        });

        bannerAdListener.setCallbackContext(callbackContext);
        banner.load();
    }

    private void hideBannerAd(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final boolean releaseAdSpace = args.getBoolean(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {

                if (releaseAdSpace) {
                    blender.setVisibility(View.GONE);
                }

                callbackContext.success();
            }
        });
    }

    private void initializeRevMob(JSONArray args, CallbackContext callbackContext) throws JSONException {
        new SessionRevMobAdListener(callbackContext);
        revmob = RevMob.start(cordova.getActivity(), args.getString(0));
        revmob.setTestingMode(testMode);
        revmob.setTimeoutInSeconds(connectionTimeout);
    }

    private void openAdLink(CallbackContext callbackContext) {
        if (revmob != null) {
            revmob.openAdLink(cordova.getActivity(), new CallbackEnableRevMobAdListener(callbackContext));
        } else {
            callbackContext.error("RevMob is not initialized.  Call the init function and try again.");
        }
    }

    private void showPopupAd(CallbackContext callbackContext) {
        if (revmob != null) {
            revmob.showPopup(cordova.getActivity(), null, new CallbackEnableRevMobAdListener(callbackContext));
        } else {
            callbackContext.error("RevMob is not initialized.  Call the init function and try again.");
        }
    }

    private void showInterstialAd(CallbackContext callbackContext) {
        if (revmob != null) {
            revmob.showFullscreen(cordova.getActivity(), new CallbackEnableRevMobAdListener(callbackContext));
        } else {
            callbackContext.error("RevMob is not initialized.  Call the init function and try again.");
        }
    }

    private void printEnvironmentInformation(CallbackContext callbackContext) {
        if (revmob != null) {
            revmob.printEnvironmentInformation(cordova.getActivity());
            callbackContext.success();
        } else {
            callbackContext.error("RevMob is not initialized.  Call the init function and try again.");
        }
    }

    private void setConnectionTimeout(JSONArray args, CallbackContext callbackContext) throws JSONException {
        connectionTimeout = args.getInt(0);
        if (revmob != null) {
            revmob.setTimeoutInSeconds(connectionTimeout);
        }
        callbackContext.success(connectionTimeout);
    }

    private void enableTestMode(JSONArray args, CallbackContext callbackContext) throws JSONException {
        testMode = args.getBoolean(0) ? RevMobTestingMode.WITH_ADS : RevMobTestingMode.WITHOUT_ADS;
        if (revmob != null) {
            revmob.setTestingMode(testMode);
        }
        callbackContext.success();
    }

    private void disableTestMode(CallbackContext callbackContext) {
        testMode = RevMobTestingMode.DISABLED;
        if (revmob != null) {
            revmob.setTestingMode(testMode);
        }
        callbackContext.success();
    }

    private int dips(int value) {
        return (int) (scale * value + 0.5f);
    }

    private void plugInBlender() {
        blender = (ViewGroup) webViewContainer.findViewWithTag("SMOOTHIE_BLENDER");
        if (blender == null) {
            blender = new FrameLayout(cordova.getActivity());
            blender.setTag("SMOOTHIE_BLENDER");
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
            float density = cordova.getActivity().getResources().getDisplayMetrics().density;
            params.height = Math.round(50 * density);
            blender.setLayoutParams(params);
            blender.setVisibility(View.GONE);
            webViewContainer.addView(blender, bannerAtTop ? 0 : webViewContainer.indexOfChild(webView) + 1);
        }
    }

    class CallbackEnableRevMobAdListener implements RevMobAdsListener {

        private CallbackContext callbackContext;


        public CallbackEnableRevMobAdListener() {

        }

        public CallbackEnableRevMobAdListener(CallbackContext callbackContext) {
            this.callbackContext = callbackContext;
        }

        public CallbackContext getCallbackContext() {
            return callbackContext;
        }

        public void setCallbackContext(CallbackContext callbackContext) {

            if (this.callbackContext != null && !this.callbackContext.isFinished()) {
                this.callbackContext.error("Yo request got stomped on by another call.");
            }
            this.callbackContext = callbackContext;
        }

        @Override
        public void onRevMobSessionIsStarted() {

            Log.d(LOGTAG, "Session started");
        }

        @Override
        public void onRevMobSessionNotStarted(String s) {

            Log.e(LOGTAG, "Session failed to start: " + s);
        }

        @Override
        public void onRevMobAdReceived() {

            Log.d(LOGTAG, "Ad Received");
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    bannerWrapper.setVisibility(View.VISIBLE);
                    bannerWrapper.bringToFront();
                }
            });
            banner.reportShowOrHidden();
            callbackContext.success();
        }

        @Override
        public void onRevMobAdNotReceived(String s) {
            Log.d(LOGTAG, "Ad Failed: " + s);
            callbackContext.error(s);
        }

        @Override
        public void onRevMobAdDisplayed() {
            Log.d(LOGTAG, "Ad Displayed");
        }

        @Override
        public void onRevMobAdDismiss() {

            Log.d(LOGTAG, "Ad Dismissed");
        }

        @Override
        public void onRevMobAdClicked() {

            Log.d(LOGTAG, "Ad Clicked");
        }

        @Override
        public void onRevMobEulaIsShown() {

            Log.d(LOGTAG, "Eula Shown");
        }

        @Override
        public void onRevMobEulaWasAcceptedAndDismissed() {

            Log.d(LOGTAG, "Eula Accepted");
        }

        @Override
        public void onRevMobEulaWasRejected() {

            Log.d(LOGTAG, "Eula Rejected");
        }
    }

    private class SessionRevMobAdListener implements RevMobAdsListener {

        private CallbackContext callbackContext;

        public SessionRevMobAdListener(CallbackContext callbackContext) {
            this.callbackContext = callbackContext;
        }

        @Override
        public void onRevMobSessionIsStarted() {
            Log.d(LOGTAG, "Session Started");
            callbackContext.success("Session Started");
        }

        @Override
        public void onRevMobSessionNotStarted(String s) {
            Log.d(LOGTAG, "Session Failed To Start");
            callbackContext.success("Session Failed To Start: " + s);

        }

        @Override
        public void onRevMobAdReceived() {

        }

        @Override
        public void onRevMobAdNotReceived(String s) {

        }

        @Override
        public void onRevMobAdDisplayed() {

        }

        @Override
        public void onRevMobAdDismiss() {

        }

        @Override
        public void onRevMobAdClicked() {

        }

        @Override
        public void onRevMobEulaIsShown() {

        }

        @Override
        public void onRevMobEulaWasAcceptedAndDismissed() {

        }

        @Override
        public void onRevMobEulaWasRejected() {

        }
    }
}