import 'dart:ffi';
import 'dart:io';

import '../../generated/native_bindings.dart';

final DynamicLibrary dynamicLibrary = Platform.isWindows
        ? DynamicLibrary.open("beacon_dll.dll")
        : DynamicLibrary.process();
final nativeLibrary = NativeLibrary(dynamicLibrary);
