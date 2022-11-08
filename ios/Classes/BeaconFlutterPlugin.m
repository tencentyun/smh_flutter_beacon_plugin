
// Created by fatboyli on 2022/09/01
// Copyright (c) 2022 Tencent. All rights reserved.
//
#import "BeaconFlutterPlugin.h"
#import <BeaconAPI_Base/BeaconBaseInterface.h>
#import <BeaconAPI_Base/BeaconReport.h>

@implementation BeaconFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"beacon_flutter"
            binaryMessenger:[registrar messenger]];
  BeaconFlutterPlugin* instance = [[BeaconFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      NSString *appKey = call.arguments[@"appKey"];
      NSString *channelId = call.arguments[@"channelId"];
      NSString *userId = call.arguments[@"userId"];
      
      if (channelId.length > 0) {
          [[BeaconReport sharedInstance] setChannelId:channelId];
      }
      if (userId.length > 0) {
          [[BeaconReport sharedInstance] setUserId:userId forAppKey:appKey];
      }
      if (appKey.length > 0) {
          BeaconReportConfig *config = [[BeaconReportConfig alloc] init];
          config.realTimeEventPollingInterval = 2;
          [[BeaconReport sharedInstance] startWithAppkey:appKey config:config];
      }
      
      result(nil);
  } else if ([@"getSdkVersion" isEqualToString:call.method]) {
      result(BEACON_SDK_VERSION);
  } else if ([@"setUserId" isEqualToString:call.method]) {
      NSString *appkey = call.arguments[@"appKey"];
      NSString *userId = call.arguments[@"userId"];
      [[BeaconReport sharedInstance] setUserId:userId forAppKey:appkey];
      result(nil);
  } else if ([@"setChannelId" isEqualToString:call.method]) {
      NSString *channelId = call.arguments[@"channelId"];
      [[BeaconReport sharedInstance] setChannelId:channelId];
      result(nil);
  } else if ([@"getQIMEI" isEqualToString:call.method]) {
      NSString *appkey = call.arguments[@"appKey"];
      QimeiContent *qimei = [[BeaconReport sharedInstance] getQimeiForAppKey:appkey];
      result(qimei.qimeiOld);
  } else if ([@"setLogLevel" isEqualToString:call.method]) {
      int logLevel = [call.arguments[@"logLevel"] intValue];
      [[BeaconReport sharedInstance] setLogLevel:logLevel];
      result(nil);
  } else if ([@"setOmgId" isEqualToString:call.method]) {
      NSString *omgId = call.arguments[@"setOmgId"];
      [[BeaconReport sharedInstance] setOmgId:omgId];
      result(nil);
  } else if ([@"reportAction" isEqualToString:call.method]) {
      NSString *appkey = call.arguments[@"appKey"];
      NSString *eventName = call.arguments[@"eventName"];
      BOOL isSucc = [call.arguments[@"isSucc"] boolValue];
      NSDictionary *params = call.arguments[@"params"];
      int eventType = [call.arguments[@"eventType"] intValue];
      
      BeaconEvent *event = [[BeaconEvent alloc] initWithAppKey:appkey code:eventName type:eventType success:isSucc params:params];
      BOOL ret = [[BeaconReport sharedInstance] reportEvent:event];
      
      result(@(ret));
  } else if ([@"setDebugEnable" isEqualToString:call.method]) {
      [[BeaconReport sharedInstance] setLogLevel:10];
      result(nil);
     } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
