import 'dart:ffi';
import 'dart:io';

final winmove = DynamicLibrary.open('./winmove.dll');

typedef NativeWinMoveFunc = Void Function(IntPtr, Int32, Int32);
typedef DartWinMoveFunc = void Function(int, int, int);

typedef NativeGetIntFunc = Int32 Function();
typedef DartGetIntFunc = int Function();

class WinMove {
  static final DartWinMoveFunc windowMove = winmove
      .lookup<NativeFunction<NativeWinMoveFunc>>("winmove")
      .asFunction();

  static final DartGetIntFunc getMouseX = winmove
      .lookup<NativeFunction<NativeGetIntFunc>>("getmousex")
      .asFunction();

  static final DartGetIntFunc getMouseY = winmove
      .lookup<NativeFunction<NativeGetIntFunc>>("getmousey")
      .asFunction();
}