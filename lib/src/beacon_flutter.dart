import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'native_library.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi';

const MethodChannel _channel = const MethodChannel('beacon_flutter');

// 通用操作接口
abstract class BaseOperator {
  Future<void> init(String appKey, String channelId,
      {String userId = ''}) async {}

  Future<void> setChannelId(String channelId) async {}

  Future<void> setUserId(String userId, String appKey) async {}

  Future<void> setDebugEnable(bool isDebug) async {}

  Future<bool> reportAction(String eventName,
      {String appKey = '',
      bool isSucceed: true,
      Map<String, String> params: const {},
      int eventType: 0}) async {
    return false;
  }

  Future<String> getQIMEI(String appKey) async {
    return '';
  }

  Future<String> getSDKVersion() async {
    return '';
  }
}

// Android相关操作接口
mixin BaseAndroidOperator {
  Future<void> setQQForAndroid(String qq) async {
    assert(Platform.isAndroid);
    if (Platform.isAndroid) {
      Map<String, dynamic> param = Map<String, dynamic>();
      param['qq'] = qq;
      await _channel.invokeMethod('setQQ', param);
    }
  }

  Future<void> setStrictModeForAndroid(bool isStrictMode) async {
    assert(Platform.isAndroid);
    if (Platform.isAndroid) {
      Map<String, dynamic> param = Map<String, dynamic>();
      param['isStrictMode'] = isStrictMode;
      await _channel.invokeMethod('setStrictMode', param);
    }
  }

  Future<void> setAdditionalInfoForAndroid(
      String appKey, Map<String, String> params) async {
    assert(Platform.isAndroid);
    if (Platform.isAndroid) {
      Map<String, dynamic> param = Map<String, dynamic>();
      param['appKey'] = appKey;
      param['params'] = params;
      await _channel.invokeMethod('setAdditionalInfo', param);
    }
  }
}

// iOS相关操作接口
mixin BaseIOSOperator {
  Future<void> setLogLevelForIOS(int logLevel) async {
    assert(Platform.isIOS);
    if (Platform.isIOS) {
      Map<String, dynamic> param = Map<String, dynamic>();
      param["logLevel"] = logLevel;
      await _channel.invokeMethod('setLogLevel', param);
    }
  }

  Future<void> setOmgIdForIOS(String setOmgId) async {
    assert(Platform.isIOS);
    if (Platform.isIOS) {
      Map<String, dynamic> param = Map<String, dynamic>();
      param["omgId"] = setOmgId;
      await _channel.invokeMethod('setOmgId', param);
    }
  }
}

/// 通过channel调用native sdk的接口集，会分别上报到Android、iOS两个分析空间
/// [BaseIOSOperator]和[BaseAndroidOperator]定义的为单端接口，只有对应的平台会上报
class BeaconNative
    with BaseAndroidOperator, BaseIOSOperator
    implements BaseOperator {
  BeaconNative._();

  static BeaconNative _instance = BeaconNative._();

  static BeaconNative get singleton => _instance;

  @override
  Future<void> init(String appKey, String channelId,
      {String userId = "", bool isDebug = false}) async {
    Map<String, dynamic> param = Map<String, dynamic>();
    param["appKey"] = appKey;
    param["channelId"] = channelId;
    param["userId"] = userId;
    param["isDebug"] = isDebug;
    if (Platform.isWindows) {
      nativeLibrary.Init(
        appKey.toNativeUtf8().cast(),
        isDebug,
        ''.toNativeUtf8().cast(),
      );
    } else {
      await _channel.invokeMethod('init', param);
    }
  }

  @override
  Future<void> setChannelId(String channelId) async {
    Map<String, dynamic> param = Map<String, dynamic>();
    param["channelId"] = channelId;
    if (Platform.isWindows) {
    } else {
      await _channel.invokeMethod('setChannelId', param);
    }
  }

  @override
  Future<void> setUserId(String userId, String appKey) async {
    Map<String, dynamic> param = Map<String, dynamic>();
    param["userId"] = userId;
    param["appKey"] = appKey;
    if (Platform.isWindows) {
    } else {
      await _channel.invokeMethod('setUserId', param);
    }
  }

  Pointer<Pointer<Int8>> strListToPointer(List<String> strings) {
    List<Pointer<Int8>> utf8PointerList = [];
    for (final item in strings) {
      utf8PointerList.add(item.toNativeUtf8().cast());
    }

    final Pointer<Pointer<Int8>> pointerPointer =
        malloc.allocate(utf8PointerList.length);

    strings.asMap().forEach((index, utf) {
      pointerPointer[index] = utf8PointerList[index];
    });

    return pointerPointer;
  }

  /// 数据上报
  @override
  Future<bool> reportAction(String eventName,
      {String appKey = '',
      bool isSucceed = true,
      Map<String, String> params: const {},
      int eventType: 0}) async {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["eventName"] = eventName;
    map["appKey"] = appKey;
    map["isSucc"] = isSucceed;
    map["params"] = params;
    map["eventType"] = eventType;
    if (Platform.isWindows) {
      List<String> keys = [];
      List<String> values = [];
      params.forEach((key, value) {
        if (value.isNotEmpty) {
          keys.add(key.toString());
          values.add(value.toString());
        }
      });
      Pointer<Pointer<Int8>> keysPointer = strListToPointer(keys);
      Pointer<Pointer<Int8>> valuessPointer = strListToPointer(values);

      nativeLibrary.Report(eventName.toNativeUtf8().cast(), keysPointer,
          valuessPointer, keys.length);
      malloc.free(keysPointer);
      malloc.free(valuessPointer);
      return true;
    } else {
      var result = await _channel.invokeMethod('reportAction', map);
      return result;
    }
  }

  // 进程退出的时候调用
  @override
  Future<void> uninit() async {
    if (Platform.isWindows) {
      nativeLibrary.Uninit();
    }
  }

  @override
  Future<String> getQIMEI(String appKey) async {
    Map<String, dynamic> param = Map<String, dynamic>();
    param["appKey"] = appKey;
    if (Platform.isWindows) {
      return '';
    } else {
      return await _channel.invokeMethod('getQIMEI', param);
    }
  }

  @override
  Future<String> getSDKVersion() async {
    if (Platform.isWindows) {
      return '';
    } else {
      return await _channel.invokeMethod('getSdkVersion');
    }
  }

  Future<void> setDebugEnable(bool isDebug) async {
    if (Platform.isWindows) {
    } else {
      return await _channel.invokeMethod('setDebugEnable', {
        'isDebug': isDebug,
      });
    }
  }
}
