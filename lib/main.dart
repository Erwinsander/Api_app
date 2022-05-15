import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:nueva_app8/models/gif.dart';

import 'package:http/http.dart' as http;

void main() => runApp(ApiApp());

class ApiApp extends StatefulWidget {
  const ApiApp({Key? key}) : super(key: key);

  @override
  State<ApiApp> createState() => _ApiAppState();
}

class _ApiAppState extends State<ApiApp> {
  late Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    http.Response response = await http.get(
      Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=cj2rgTCSfCE1IjvaT68bqFbX3EInLCNG&limit=10&rating=g"),
    );

    List<Gif> gifs = [];

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }

      return gifs;
    } else {
      throw Exception("falló la conexión");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Api App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Api App"),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return GridView.count(
                crossAxisCount: 2,
                children: _listGifs(snapshot.data),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("Error");
            }
            return Text("");
          },
        ),
      ),
    );
  }

  List<Widget> _listGifs(data) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Expanded(
            child: Image.network(
              gif.url,
              fit: BoxFit.fill,
            ),
          ),
        ],
      )));
    }

    return gifs;
  }
}
