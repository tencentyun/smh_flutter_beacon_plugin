// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void Init(
    ffi.Pointer<ffi.Int8> appKey,
    bool isDebug,
    ffi.Pointer<ffi.Int8> dbDirPath,
  ) {
    return _Init(
      appKey,
      isDebug ? 1 : 0,
      dbDirPath,
    );
  }

  late final _Init_ptr = _lookup<ffi.NativeFunction<_c_Init>>('Init');
  late final _dart_Init _Init = _Init_ptr.asFunction<_dart_Init>();

  void Uninit() {
    return _Uninit();
  }

  late final _Uninit_ptr = _lookup<ffi.NativeFunction<_c_Uninit>>('Uninit');
  late final _dart_Uninit _Uninit = _Uninit_ptr.asFunction<_dart_Uninit>();

  late final ffi.Pointer<ffi.Int32> _nbeacondll =
      _lookup<ffi.Int32>('nbeacondll');

  int get nbeacondll => _nbeacondll.value;

  set nbeacondll(int value) => _nbeacondll.value = value;

  void Report(
    ffi.Pointer<ffi.Int8> eventKey,
    ffi.Pointer<ffi.Pointer<ffi.Int8>> keys,
    ffi.Pointer<ffi.Pointer<ffi.Int8>> values,
    int length,
  ) {
    return _Report(
      eventKey,
      keys,
      values,
      length,
    );
  }

  late final _Report_ptr = _lookup<ffi.NativeFunction<_c_Report>>('Report');
  late final _dart_Report _Report = _Report_ptr.asFunction<_dart_Report>();

  int fnbeacondll() {
    return _fnbeacondll();
  }

  late final _fnbeacondll_ptr =
      _lookup<ffi.NativeFunction<_c_fnbeacondll>>('fnbeacondll');
  late final _dart_fnbeacondll _fnbeacondll =
      _fnbeacondll_ptr.asFunction<_dart_fnbeacondll>();
}

const int __bool_true_false_are_defined = 1;

const int false_1 = 0;

const int true_1 = 1;

typedef _c_Init = ffi.Void Function(
  ffi.Pointer<ffi.Int8> appKey,
  ffi.Uint8 isDebug,
  ffi.Pointer<ffi.Int8> dbDirPath,
);

typedef _dart_Init = void Function(
  ffi.Pointer<ffi.Int8> appKey,
  int isDebug,
  ffi.Pointer<ffi.Int8> dbDirPath,
);

typedef _c_Uninit = ffi.Void Function();

typedef _dart_Uninit = void Function();

typedef _c_Report = ffi.Void Function(
  ffi.Pointer<ffi.Int8> eventKey,
  ffi.Pointer<ffi.Pointer<ffi.Int8>> keys,
  ffi.Pointer<ffi.Pointer<ffi.Int8>> values,
  ffi.Int32 length,
);

typedef _dart_Report = void Function(
  ffi.Pointer<ffi.Int8> eventKey,
  ffi.Pointer<ffi.Pointer<ffi.Int8>> keys,
  ffi.Pointer<ffi.Pointer<ffi.Int8>> values,
  int length,
);

typedef _c_fnbeacondll = ffi.Int32 Function();

typedef _dart_fnbeacondll = int Function();