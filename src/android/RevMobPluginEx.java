package com.blakgeek.cordova.plugin.revmob;


import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.revmob.RevMobAdsListener;
import com.revmob.ads.banner.RevMobBanner;
import com.revmob.cordova.RevMobPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class RevMobPluginEx extends RevMobPlugin {

    private float scale;
    private RevMobBanner banner;
    private ViewGroup bannerWrapper;
    private boolean bannerAtTop = true;

    @Override
    protected void pluginInitialize() {
        super.pluginInitialize();
        scale = cordova.getActivity().getResources().getDisplayMetrics().density;
        banner = new RevMobBanner(cordova.getActivity(), new BannerAdListener());


        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // TODO: deal with scaling banner for tablets
                bannerWrapper = new RelativeLayout(cordova.getActivity());
                bannerWrapper.setLayoutParams(new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                bannerWrapper.setVisibility(View.GONE);

                // set the size to the defaults so the banner can be centered
                RelativeLayout.LayoutParams bannerLayout = new RelativeLayout.LayoutParams(dips(RevMobBanner.DEFAULT_WIDTH_IN_DIP), dips(RevMobBanner.DEFAULT_HEIGHT_IN_DIP));
                bannerLayout.addRule(RelativeLayout.CENTER_HORIZONTAL);
                banner.setLayoutParams(bannerLayout);

                // add the views to the main ViewGroup
                ViewGroup parentView = (ViewGroup) webView.getParent();
                bannerWrapper.addView(banner);
                parentView.addView(bannerWrapper, 0);
            }
        });
    }


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if ("showBanner".equals(action)) {
            final boolean showAtTop = args.getBoolean(0);
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (showAtTop != bannerAtTop) {
                        ViewGroup parent = (ViewGroup) webView.getParent();
                        parent.removeView(bannerWrapper);
                        parent.addView(bannerWrapper, showAtTop ? 0 : 1);
                        bannerAtTop = showAtTop;
                    }
                    bannerWrapper.setVisibility(View.VISIBLE);
                    banner.load();
                }
            });

        } else if ("hideBanner".equals(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    bannerWrapper.setVisibility(View.GONE);
                }
            });
        } else {
            return super.execute(action, args, callbackContext);
        }

        return true;
    }

    private int dips(int value) {
        return (int) (scale * value + 0.5f);
    }

    class BannerAdListener implements RevMobAdsListener {

        @Override
        public void onRevMobSessionIsStarted() {

        }

        @Override
        public void onRevMobSessionNotStarted(String s) {

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