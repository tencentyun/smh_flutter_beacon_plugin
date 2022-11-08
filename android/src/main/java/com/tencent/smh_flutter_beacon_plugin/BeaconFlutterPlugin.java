package com.tencent.smh_flutter_beacon_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.beacon.event.open.BeaconConfig;
import com.tencent.beacon.event.open.BeaconEvent;
import com.tencent.beacon.event.open.BeaconReport;
import com.tencent.beacon.event.open.EventResult;
import com.tencent.beacon.event.open.EventType;
import com.tencent.qimei.sdk.Qimei;
import com.tencent.qimei.sdk.QimeiSDK;


import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * TheBeaconFlutterPlugin contain all the method for dart to call
 *
 * <p>see all method in onMethodCall : init,setDebugEnable eg..
 * {@code null}.
 *
 * @author lukehuang
 * @date 2020-05-05
 * @description
 */
public class BeaconFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    private Context mContext;
    private static final String CHANNEL_NAME = "beacon_flutter";
    private MethodChannel channel;
    private static final String TAG = "BeaconFlutterPlugin";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        setupChannel(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final BeaconFlutterPlugin plugin = new BeaconFlutterPlugin();
        plugin.setupChannel(registrar.messenger(), registrar.context().getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        mContext = null;
    }

    private void setupChannel(BinaryMessenger messenger, Context context) {
        mContext = context;
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        String methodName = methodCall.method;
        Log.d(TAG, "onMethodCall: " + methodName);
        switch (methodName) {
            case "init": {
                String appKey = methodCall.argument("appKey");
                String channelId = methodCall.argument("channelId");
                String userId = methodCall.argument("userId");
                String appVersion = methodCall.argument("appVersion");

                QimeiSDK.getInstance(appKey).setChannelID(channelId)
                        .setAppVersion(appVersion)
                        .addUserId(appKey,userId)
                        .init(mContext);
                BeaconConfig config = BeaconConfig.builder()
                        .setModel(Build.MODEL)
                        .setNeedInitQimei(false)
                        .setNormalPollingTime(2)
                        .build();
                BeaconReport beaconReport = BeaconReport.getInstance();
                beaconReport.setChannelID(channelId);
                beaconReport.setUserID(appKey,userId);

                try{
                    beaconReport.start(mContext, appKey, config);
                    result.success(true);
                }catch (Exception e){
                    result.success(false);
                }


            }
            break;
            case "setDebugEnable": {
                Boolean isDebug = methodCall.argument("isDebug");
                BeaconReport.getInstance().setLogAble(isDebug);
                result.success(true);
            }
            break;
            case "setChannelId": {
                String channelId = methodCall.argument("channelId");
                BeaconReport.getInstance().setChannelID(channelId);
                result.success(true);
            }
            break;
            case "setUserId": {
                String userId = methodCall.argument("userId");
                String appKey = methodCall.argument("appKey");
                BeaconReport.getInstance().setUserID(appKey, userId);
                result.success(true);
            }
            break;
            case "reportAction": {
                String eventName = methodCall.argument("eventName");
                Boolean isSucceed = methodCall.argument("isSucc");
                Map<String, String> params = methodCall.argument("params");
                String  appKey = methodCall.argument("appKey");
                int eventType = methodCall.argument("eventType");
                EventType type = EventType.values()[eventType];

                BeaconEvent event = BeaconEvent.builder()
                        .withAppKey(appKey)
                        .withParams(params)
                        .withCode(eventName)
                        .withType(type)
                        .withIsSucceed(isSucceed)
                        .build();
                EventResult reportResult =  BeaconReport.getInstance().report(event);
                if(reportResult == null)
                {
                    result.success(false);
                }else{
                    boolean isSuccess = reportResult.isSuccess();
                    result.success(isSuccess);
                }
            }
            break;
            case "getQIMEI": {
                String appKey = methodCall.argument("appKey");
                Qimei qimei = BeaconReport.getInstance().getQimei(appKey);
                result.success(qimei.getQimei16());
            }
            break;
            case "getSdkVersion": {
                String version = BeaconReport.getInstance().getSDKVersion();
                result.success(version);
            }
            break;
            case "setQQ": {
                String qq = methodCall.argument("qq");
                BeaconReport.getInstance().setQQ(qq);
                result.success(true);
            }
            break;
            case "setStrictMode": {
                Boolean isStrictMode = methodCall.argument("isStrictMode");
                BeaconReport.getInstance().setStrictMode(isStrictMode);
                result.success(true);
            }
            break;
            case "setAdditionalInfo": {
                String appKey = methodCall.argument("appKey");
                Map<String, String> params = methodCall.argument("params");
                BeaconReport.getInstance().setAdditionalParams(appKey,params);
                result.success(true);
            }
            break;
            default:{

            }
            break;
        }
    }
}
