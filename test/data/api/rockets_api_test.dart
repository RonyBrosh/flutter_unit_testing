import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unit_testing/data/api/rockets_api.dart';
import 'package:flutter_unit_testing/data/mapper/mapper.dart';
import 'package:flutter_unit_testing/domain/model/rocket.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientMock extends Mock implements Client {}

class MapperMock extends Mock implements Mapper<String, List<Rocket>> {}

class RocketsMock extends Mock implements List<Rocket> {}

class ExceptionMock extends Mock implements Exception {}

void main() {
  final ClientMock client = ClientMock();
  final MapperMock mapper = MapperMock();
  final RocketsApi sut = RocketsApi(
    client: client,
    mapper: mapper,
  );

  group('getRockets', () {
    test("getRockets SHOULD return a list of rockets WHEN api succeeds", () async {
      final Uri uri = Uri.https("api.spacexdata.com", "/v4/rockets");
      const String body = "Fake body";
      final Response response = Response(body, 200);
      final List<Rocket> rockets = RocketsMock();
      when(() => client.get(uri)).thenAnswer((invocation) => Future.value(response));
      when(() => mapper.call(body)).thenReturn(rockets);

      final result = await sut.getRockets();

      expect(result, rockets);
    });

    test("getRockets SHOULD throw an exception WHEN api fails",(){
      final Uri uri = Uri.https("api.spacexdata.com", "/v4/rockets");
      final Exception exception =  ExceptionMock();
      when(() => client.get(uri)).thenAnswer((invocation) => Future.error(exception));

      expect(() => sut.getRockets(), throwsA(exception));
    });

    test("getRockets SHOULD throw an exception WHEN mapper fails",(){
      final Uri uri = Uri.https("api.spacexdata.com", "/v4/rockets");
      final Exception exception =  ExceptionMock();
      const String body = "Fake body";
      final Response response = Response(body, 200);
      when(() => client.get(uri)).thenAnswer((invocation) => Future.value(response));
      when(() => mapper.call(body)).thenThrow(exception);

      expect(() => sut.getRockets(), throwsA(exception));
    });
  });
}
