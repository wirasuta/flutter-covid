import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<dynamic> fetchSummary() async {
  final response =
      await http.get('https://kawalcovid19.harippe.id/api/summary');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load summary');
  }
}

Future<dynamic> fetchNews() async {
  final response = await http
      .get('http://newsapi.org/v2/top-headlines?q=covid-19&apiKey=<API_KEY>');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var text = response.body;
    log('data: $text');
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load news');
  }
}
