// File created by
// Lung Razvan <long1eu>
// on 26/08/2019

import 'dart:convert';
import 'dart:ffi';

import 'package:h3/main.dart';
import 'package:test/test.dart';

const double precisionErrorTolerance = 1e-10;

void main() {
  setUpAll(
      () => initializeH3((_) => DynamicLibrary.open('ios/build/libh3.so')));

  test('geoToH3', () {
    expect(geoToH3(GeoCoord.degrees(lat: 79.2423985098, lon: 38.0234070080), 0),
        0x8001fffffffffff);
    expect(
        geoToH3(GeoCoord.degrees(lat: 79.2209863563, lon: -107.4292022430), 0),
        0x8003fffffffffff);
    expect(
        geoToH3(GeoCoord.degrees(lat: 74.9284343892, lon: 145.3562419228), 0),
        0x8005fffffffffff);
  });

  test('h3ToGeo', () {
    expect(h3ToGeo(0x8001fffffffffff),
        GeoCoord.degrees(lat: 79.2423985098, lon: 38.0234070080));
    expect(h3ToGeo(0x8003fffffffffff),
        GeoCoord.degrees(lat: 79.2209863563, lon: -107.4292022430));
    expect(h3ToGeo(0x8005fffffffffff),
        GeoCoord.degrees(lat: 74.9284343892, lon: 145.3562419228));
  });

  test('h3ToGeoBoundary', () {
    expect(h3ToGeoBoundary(0x8a8f5a980387fff), <GeoCoord>[
      GeoCoord.degrees(lat: -9.361697060, lon: -78.582037761),
      GeoCoord.degrees(lat: -9.362128022, lon: -78.582655266),
      GeoCoord.degrees(lat: -9.362873639, lon: -78.582586800),
      GeoCoord.degrees(lat: -9.363188292, lon: -78.581900827),
      GeoCoord.degrees(lat: -9.362757328, lon: -78.581283323),
      GeoCoord.degrees(lat: -9.362011713, lon: -78.581351792),
    ]);
    expect(h3ToGeoBoundary(0x8a2769da3587fff), <GeoCoord>[
      GeoCoord.degrees(lat: 44.641731384, lon: -82.135842406),
      GeoCoord.degrees(lat: 44.641506337, lon: -82.136798146),
      GeoCoord.degrees(lat: 44.640824436, lon: -82.136981488),
      GeoCoord.degrees(lat: 44.640367585, lon: -82.136209116),
      GeoCoord.degrees(lat: 44.640592624, lon: -82.135253397),
      GeoCoord.degrees(lat: 44.641274521, lon: -82.135070029),
    ]);
    expect(h3ToGeoBoundary(0x8a3d6628221ffff), <GeoCoord>[
      GeoCoord.degrees(lat: 38.026712729, lon: 85.707804486),
      GeoCoord.degrees(lat: 38.025989433, lon: 85.707767610),
      GeoCoord.degrees(lat: 38.025619227, lon: 85.708541471),
      GeoCoord.degrees(lat: 38.025972308, lon: 85.709352214),
      GeoCoord.degrees(lat: 38.026695600, lon: 85.709389108),
      GeoCoord.degrees(lat: 38.027065815, lon: 85.708615242),
    ]);
  });

  test('maxKringSize', () {
    for (int i = 0; i < 5; i++) {
      expect(maxKringSize(i), 3 * i * (i + 1) + 1);
    }
  });

  test('hexRange', () {
    final List<int> result = hexRange(0x845ad1bffffffff, 2);

    expect(
      result,
      <int>[
        0x845ad1bffffffff,
        0x845ad19ffffffff,
        0x845ad11ffffffff,
        0x845ad13ffffffff,
        0x845adcdffffffff,
        0x845ac27ffffffff,
        0x845ac25ffffffff,
        0x845ad53ffffffff,
        0x845ad57ffffffff,
        0x845ad1dffffffff,
        0x845ad15ffffffff,
        0x845ad17ffffffff,
        0x845ade9ffffffff,
        0x845adc5ffffffff,
        0x845adc1ffffffff,
        0x845adc9ffffffff,
        0x845ac23ffffffff,
        0x845ac21ffffffff,
        0x845ac2dffffffff,
      ],
    );
  });

  test('hexRangeDistances', () {
    final Map<int, int> result = hexRangeDistances(0x845ad1bffffffff, 2);

    expect(
      result,
      <int, int>{
        0x845ad1bffffffff: 0,
        0x845ad19ffffffff: 1,
        0x845ad11ffffffff: 1,
        0x845ad13ffffffff: 1,
        0x845adcdffffffff: 1,
        0x845ac27ffffffff: 1,
        0x845ac25ffffffff: 1,
        0x845ad53ffffffff: 2,
        0x845ad57ffffffff: 2,
        0x845ad1dffffffff: 2,
        0x845ad15ffffffff: 2,
        0x845ad17ffffffff: 2,
        0x845ade9ffffffff: 2,
        0x845adc5ffffffff: 2,
        0x845adc1ffffffff: 2,
        0x845adc9ffffffff: 2,
        0x845ac23ffffffff: 2,
        0x845ac21ffffffff: 2,
        0x845ac2dffffffff: 2,
      },
    );
  });

  test('hexRanges', () {
    final List<int> result = hexRanges(<int>{
      0x89283080ddbffff,
      0x89283080c37ffff,
      0x89283080c27ffff,
      0x89283080d53ffff,
      0x89283080dcfffff,
      0x89283080dc3ffff,
    }, 1);

    expect(
      result,
      <int>[
        0x89283080ddbffff,
        0x89283080cafffff,
        0x89283080c37ffff,
        0x89283080dcbffff,
        0x89283080dc3ffff,
        0x89283080dd3ffff,
        0x89283080ca7ffff,
        0x89283080c37ffff,
        0x89283080c33ffff,
        0x89283080c23ffff,
        0x89283080c27ffff,
        0x89283080dcbffff,
        0x89283080ddbffff,
        0x89283080cafffff,
        0x89283080c27ffff,
        0x89283080c23ffff,
        0x89283080c2fffff,
        0x89283080d5bffff,
        0x89283080d53ffff,
        0x89283080dcbffff,
        0x89283080c37ffff,
        0x89283080d53ffff,
        0x89283080c27ffff,
        0x89283080d5bffff,
        0x89283080d43ffff,
        0x89283080d57ffff,
        0x89283080dcfffff,
        0x89283080dcbffff,
        0x89283080dcfffff,
        0x89283080dcbffff,
        0x89283080d53ffff,
        0x89283080d57ffff,
        0x89283080d1bffff,
        0x89283080dc7ffff,
        0x89283080dc3ffff,
        0x89283080dc3ffff,
        0x89283080ddbffff,
        0x89283080dcbffff,
        0x89283080dcfffff,
        0x89283080dc7ffff,
        0x89283080dd7ffff,
        0x89283080dd3ffff,
      ],
    );
  });

  test('kRing', () {
    final List<int> result = kRing(0x89283082b7bffff, 2);

    expect(
      result,
      <int>[
        0x89283082b7bffff,
        0x89283082b4fffff,
        0x89283080cb7ffff,
        0x89283082b6bffff,
        0x89283082b63ffff,
        0x89283082b73ffff,
        0x89283082b47ffff,
        0x89283082b43ffff,
        0x89283082b4bffff,
        0x89283080cb3ffff,
        0x89283080ca3ffff,
        0x89283080ca7ffff,
        0x89283080dd3ffff,
        0x89283082b6fffff,
        0x89283082b67ffff,
        0x89283082b77ffff,
        0x89283082b0fffff,
        0x89283082b0bffff,
        0x89283082b57ffff,
      ],
    );
  });

  test('kRingDistances', () {
    final Map<int, int> result = kRingDistances(0x89283082b7bffff, 3);

    expect(
      result,
      <int, int>{
        0x89283082b7bffff: 0,
        0x89283082b4fffff: 1,
        0x89283080cb7ffff: 1,
        0x89283082b6bffff: 1,
        0x89283082b63ffff: 1,
        0x89283082b73ffff: 1,
        0x89283082b47ffff: 1,
        0x89283082b43ffff: 2,
        0x89283082b4bffff: 2,
        0x89283080cb3ffff: 2,
        0x89283080ca3ffff: 2,
        0x89283080ca7ffff: 2,
        0x89283080dd3ffff: 2,
        0x89283082b6fffff: 2,
        0x89283082b67ffff: 2,
        0x89283082b77ffff: 2,
        0x89283082b0fffff: 2,
        0x89283082b0bffff: 2,
        0x89283082b57ffff: 2,
        0x89283082b53ffff: 3,
        0x89283082b5bffff: 3,
        0x89283080c97ffff: 3,
        0x89283080c87ffff: 3,
        0x89283080cbbffff: 3,
        0x89283080cabffff: 3,
        0x89283080cafffff: 3,
        0x89283080ddbffff: 3,
        0x89283080dc3ffff: 3,
        0x89283080dd7ffff: 3,
        0x89283080d9bffff: 3,
        0x89283080d93ffff: 3,
        0x89283082b2bffff: 3,
        0x89283082b3bffff: 3,
        0x89283082b07ffff: 3,
        0x89283082b03ffff: 3,
        0x89283082b1bffff: 3,
        0x89283082bcfffff: 3,
      },
    );
  });

  test('hexRing', () {
    List<int> result = hexRing(0x89283080dcbffff, 0);
    expect(result.length, 1);
    expect(result.first, 0x89283080dcbffff);

    result = hexRing(0x89283080dcbffff, 1);
    expect(
      result,
      <int>[
        0x89283080ddbffff,
        0x89283080c37ffff,
        0x89283080c27ffff,
        0x89283080d53ffff,
        0x89283080dcfffff,
        0x89283080dc3ffff,
      ],
    );
  });

  test('maxPolyfillSize', () {
    const List<GeoCoord> geofence = <GeoCoord>[
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519396),
      GeoCoord(lat: 0.6595011102219, lon: -2.1359434279405),
      GeoCoord(lat: 0.6583348114025, lon: -2.1354884206045),
      GeoCoord(lat: 0.6581220034068, lon: -2.1382437718946),
      GeoCoord(lat: 0.6594479998527, lon: -2.1384597563896),
      GeoCoord(lat: 0.6599990002976, lon: -2.1376771158464),
    ];

    const List<GeoCoord> emptyGeofence = <GeoCoord>[
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519394),
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519395),
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519396),
    ];

    const List<List<GeoCoord>> holes = <List<GeoCoord>>[
      <GeoCoord>[
        GeoCoord(lat: 0.6595072188743, lon: -2.1371053983433),
        GeoCoord(lat: 0.6591482046471, lon: -2.1373141048153),
        GeoCoord(lat: 0.6592295020837, lon: -2.1365222838402),
      ],
    ];

    expect(maxPolyfillSize(GeoPolygon(geofence, <List<GeoCoord>>[]), 9), 5613);
    expect(maxPolyfillSize(GeoPolygon(geofence, holes), 9), 5613);
    expect(
        maxPolyfillSize(GeoPolygon(emptyGeofence, <List<GeoCoord>>[]), 9), 15);
  });

  test('polyfill', () {
    const List<GeoCoord> geofence = <GeoCoord>[
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519396),
      GeoCoord(lat: 0.6595011102219, lon: -2.1359434279405),
      GeoCoord(lat: 0.6583348114025, lon: -2.1354884206045),
      GeoCoord(lat: 0.6581220034068, lon: -2.1382437718946),
      GeoCoord(lat: 0.6594479998527, lon: -2.1384597563896),
      GeoCoord(lat: 0.6599990002976, lon: -2.1376771158464),
    ];

    const List<GeoCoord> emptyGeofence = <GeoCoord>[
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519394),
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519395),
      GeoCoord(lat: 0.659966917655, lon: -2.1364398519396),
    ];

    const List<List<GeoCoord>> holes = <List<GeoCoord>>[
      <GeoCoord>[
        GeoCoord(lat: 0.6595072188743, lon: -2.1371053983433),
        GeoCoord(lat: 0.6591482046471, lon: -2.1373141048153),
        GeoCoord(lat: 0.6592295020837, lon: -2.1365222838402),
      ],
    ];

    List<int> result = polyfill(GeoPolygon(geofence, <List<GeoCoord>>[]), 9);
    expect(result.where((int it) => it != 0).length, 1253);

    result = polyfill(GeoPolygon(geofence, holes), 9);
    expect(result.where((int it) => it != 0).length, 1214);

    result = polyfill(GeoPolygon(emptyGeofence, <List<GeoCoord>>[]), 9);
    expect(result.where((int it) => it != 0).length, 0);
  });
}

// ignore: unused_element
String _printGeoJson(List<int> data) {
  final String value = jsonEncode(<String, dynamic>{
    'type': 'FeatureCollection',
    'features': data.map(_h3ToGeoJson).toList(),
  });
  print(value);

  return value;
}

Map<String, dynamic> _h3ToGeoJson(int h3, [Map<String, dynamic> properties]) {
  final List<List<double>> coordinates = h3ToGeoBoundary(h3)
      .map((GeoCoord it) => <double>[it.lonDeg, it.latDeg])
      .toList();

  return <String, dynamic>{
    'type': 'Feature',
    'properties': properties ?? <String, dynamic>{},
    'geometry': <String, dynamic>{
      'type': 'Polygon',
      'coordinates': <List<List<double>>>[
        <List<double>>[
          ...coordinates,
          coordinates[0],
        ]
      ]
    }
  };
}

// ignore: unused_element
String _hex(int h3) => '0x${h3.toRadixString(16)}';
