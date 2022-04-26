import 'dart:convert';  //json
import 'package:guncelhaberler/models/article.dart';
import 'package:guncelhaberler/models/haber.dart';
import 'package:http/http.dart' as http;


class HaberServisi {
  static final HaberServisi _singleton = HaberServisi._internal();
  HaberServisi._internal();

  factory HaberServisi() {
    return _singleton;
  }

  static Future<List<Articles>?> getNews() async {
    String url =('https://newsapi.org/v2/top-headlines?country=tr&category=business&apiKey=d4f3fab6922846f38719a69523457b2e'); //HTTP İMPOTR ET
    final response = await http.get(Uri.parse(url),);
    if (response.body.isNotEmpty) {
      final responseJson = json.decode(response.body);
      Haber haber = Haber.fromJson(responseJson);
      return haber.articles;
    }

    return null;
  }
}



