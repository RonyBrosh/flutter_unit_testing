import 'package:flutter_unit_testing/data/mapper/mapper.dart';
import 'package:flutter_unit_testing/domain/model/rocket.dart';
import 'package:http/http.dart';

class RocketsApi {
  final Client client;
  final Mapper<String, List<Rocket>> mapper;

  RocketsApi({
    required this.client,
    required this.mapper,
  });

  Future<List<Rocket>> getRockets() async {
    final Uri uri = Uri.https("api.spacexdata.com", "/v4/rockets");
    final Response response = await client.get(uri);
    return Future.value(mapper(response.body));
  }
}
