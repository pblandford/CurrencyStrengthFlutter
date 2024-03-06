import 'package:fluttersandpit/data/Config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttersandpit/entities/PercentSet.dart';
import 'package:fluttersandpit/entities/Period.dart';


class GetPercentSets {

  Future<Iterable<PercentSet>> call(Period period, int sample) async {
    final response = await http.get(
        Uri.parse("${Config.serverUrl}/percentages/${period.name}/$sample"));

    if (response.statusCode == 200) {
      final maps = jsonDecode(response.body) as List<dynamic>;
      return maps.map((m) =>
          PercentSet.fromJson(m));
    } else {
      throw Exception("Received status ${response.statusCode}");
    }
  }
}