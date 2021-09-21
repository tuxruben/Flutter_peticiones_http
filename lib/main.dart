import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peticiones_http/models/Gif.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Gif>> _listadoGifs;
  Future<List<Gif>> getGifs() async {
    final response = await http.get(Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=foYEvqb80cC0nvVnHb9NNkVCKPvWDfR0&limit=25&rating=g"));
    List<Gif> gifs = [];
    if (response.statusCode == 200) {
      String Body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(Body);
      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }
      return gifs;
    } else {
      throw Exception("Error en la conexion");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoGifs = getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return GridView.count(
                  crossAxisCount: 2, children: _listGifs(snapshot.data));
            } else if (snapshot.hasError) {
              print(snapshot.hasError);
              return Text("error");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(Card(
          child: Column(
        children: [
          Expanded(child: Image.network(gif.url, fit: BoxFit.fill)),
        ],
      )));
    }
    return gifs;
  }
}
