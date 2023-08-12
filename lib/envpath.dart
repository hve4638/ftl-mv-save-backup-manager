import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef GetEnvPathNativeFunc = Pointer<Utf8> Function();
typedef GetEnvPathDartFunc = Pointer<Utf8> Function();

final DynamicLibrary envpath = DynamicLibrary.open('envpath.dll');
final GetEnvPathDartFunc __personal =
  envpath.lookupFunction<GetEnvPathNativeFunc, GetEnvPathDartFunc>('Personal');
final GetEnvPathDartFunc __desktop =
  envpath.lookupFunction<GetEnvPathNativeFunc, GetEnvPathDartFunc>('Desktop');

String personal() {
  return __personal().toDartString();
}

String desktop() {
  return __desktop().toDartString();
}