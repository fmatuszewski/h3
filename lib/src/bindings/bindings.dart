// File created by
// Lung Razvan <long1eu>
// on 22/08/2019

import 'dart:ffi';

import 'package:h3/src/bindings/types.dart';
import 'package:h3/src/ffi/dylib_utils.dart';

import 'signatures.dart';

typedef LibraryLoader = DynamicLibrary Function(String name);

class _H3Bindings {
  DynamicLibrary h3;

  void initialize([LibraryLoader loader]) {
    h3 = loader?.call('h3') ?? dlopenPlatformSpecific('h3');

    geoToH3 =
        h3.lookup<NativeFunction<geoToH3_native_t>>('geoToH3').asFunction();
    h3ToGeo =
        h3.lookup<NativeFunction<h3ToGeo_native_t>>('h3ToGeo').asFunction();
    h3ToGeoBoundary = h3
        .lookup<NativeFunction<h3ToGeoBoundary_dart_native_t>>(
            'h3ToGeoBoundary_shim')
        .asFunction();
    hexRange =
        h3.lookup<NativeFunction<hexRange_native_t>>('hexRange').asFunction();
    hexRangeDistances = h3
        .lookup<NativeFunction<hexRangeDistances_native_t>>('hexRangeDistances')
        .asFunction();
    hexRanges =
        h3.lookup<NativeFunction<hexRanges_native_t>>('hexRanges').asFunction();
    kRing = h3.lookup<NativeFunction<kRing_native_t>>('kRing').asFunction();
    kRingDistances = h3
        .lookup<NativeFunction<kRingDistances_native_t>>('kRingDistances')
        .asFunction();
    hexRing =
        h3.lookup<NativeFunction<hexRing_native_t>>('hexRing').asFunction();
    maxPolyfillSize = h3
        .lookup<NativeFunction<maxPolyfillSize_dart_native_t>>(
            'maxPolyfillSize_shim')
        .asFunction();
    polyfill = h3
        .lookup<NativeFunction<polyfill_dart_native_t>>('polyfill_shim')
        .asFunction();
  }

  /// Find the H3 index of the resolution [res] cell containing the lat/lon [g]
  int Function(Pointer<GeoCoordNative> g, int res) geoToH3;

  /// Find the lat/lon center point g of the cell h3
  void Function(int h3, Pointer<GeoCoordNative> g) h3ToGeo;

  /// Give the cell boundary in lat/lon coordinates for the cell h3
  int Function(int h3, Pointer<GeoCoordNative> g) h3ToGeoBoundary;

  /// Hexagons neighbors in all directions, assuming no pentagons
  int Function(int origin, int k, Pointer<Uint64> out) hexRange;

  /// Hexagon neighbors in all directions, reporting distance from origin
  int Function(int origin, int k, Pointer<Uint64> out, Pointer<Int32> distances)
      hexRangeDistances;

  /// Collection of hex rings sorted by ring for all given hexagons
  int Function(Pointer<Uint64> h3Set, int length, int k, Pointer<Uint64> out)
      hexRanges;

  /// Hexagon neighbors in all directions
  void Function(int origin, int k, Pointer<Uint64> out) kRing;

  /// Hexagon neighbors in all directions, reporting distance from origin
  void Function(
          int origin, int k, Pointer<Uint64> out, Pointer<Int32> distances)
      kRingDistances;

  /// Hollow hexagon ring at some origin
  int Function(int origin, int k, Pointer<Uint64> out) hexRing;

  /// Maximum number of hexagons in the geofence
  int Function(
    Pointer<GeoCoordNative> geofence,
    int geofenceNum,
    Pointer<Pointer<GeoCoordNative>> holes,
    Pointer<Int32> holesSizes,
    int holesNum,
    int res,
  ) maxPolyfillSize;

  /// Hexagons within the given geofence
  void Function(
    Pointer<GeoCoordNative> geofence,
    int geofenceNum,
    Pointer<Pointer<GeoCoordNative>> holes,
    Pointer<Int32> holesSizes,
    int holesNum,
    int res,
    Pointer<Uint64> out,
  ) polyfill;
}

_H3Bindings _cachedBindings;

_H3Bindings get bindings => _cachedBindings ??= _H3Bindings();
