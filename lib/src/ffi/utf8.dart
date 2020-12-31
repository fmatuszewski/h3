// File created by
// Lung Razvan <long1eu>
// on 22/08/2019

import 'dart:convert';
import 'dart:ffi';

import 'arena.dart';
import 'package:ffi/ffi.dart';

/// Represents a String in C memory, managed by an [Arena].
class Utf8 extends Struct {
  @Uint8()
  int char;

  /// Allocates a [CString] in the current [Arena] and populates it with
  /// [dartStr].
  static Pointer<Utf8> fromString(String dartStr) => Utf8.fromStringArena(Arena.current(), dartStr);

  /// Allocates a [CString] in [arena] and populates it with [dartStr].
  static Pointer<Utf8> fromStringArena(Arena arena, String dartStr) => arena.scoped(create(dartStr));

  /// Allocate a [CString] not managed in and populates it with [dartStr].
  ///
  /// This [CString] is not managed by an [Arena]. Please ensure to [free] the
  /// memory manually!
  static Pointer<Utf8> create(String dartStr) {
    final List<int> units = utf8.encode(dartStr);
    final Pointer<Utf8> str = allocate<Utf8>(count:units.length + 1 );
    for (int i = 0; i < units.length; ++i) {
      str.elementAt(i).ref.char = units[i];
    }
    str.elementAt(units.length).ref.char = 0;
    return str.cast();
  }

  /// Read the string for C memory into Dart.
  @override
  String toString() {
    final Pointer<Utf8> str = addressOf;
    // ignore: unrelated_type_equality_checks
    if (str == nullptr) {
      return null;
    }
    int len = 0;
    while (str.elementAt(++len).ref.char != 0);
    final List<int> units = List<int>(len);
    for (int i = 0; i < len; ++i) {
      units[i] = str.elementAt(i).ref.char;
    }
    return utf8.decode(units);
  }
}
