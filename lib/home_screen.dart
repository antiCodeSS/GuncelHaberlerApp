import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guncelhaberler/models/article.dart';
import 'package:guncelhaberler/models/haberCekme.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURLApp(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: true, forceWebView: true);
  } else {
    throw ' Error $url';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.titleApp}) : super(key: key);

  final String titleApp;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectivityResult _connectionResult = ConnectivityResult.none;

  Future<void> _checkInternetConnectivity() async {
    late ConnectivityResult result;

    result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      _showDialog('İnternet bağlantısı yok',
          "Devam etmek için lütfen internet bağlantınızı kontrol edip TAMAM'a basın.");
    }
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                      const HomePage(titleApp: 'GÜNCEL HABERLER')));
                },
                child: const Text(
                  'TAMAM',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          );
        });
  }

  List<Articles> articles = [];
  @override
  void initState() {
    super.initState();

    HaberServisi.getNews().then((value) {
      setState(() {
        articles.addAll(value ?? []);
      });
    });
    _checkInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleApp),
        centerTitle: true,
      ),

      body: Center(
          child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Column(
                      children: [
                        if (articles[index].author != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              articles[index].author!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        if (articles[index].urlToImage != null)
                          Image.network(
                            articles[index].urlToImage!,
                            errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                          ),

                        if (articles[index].title != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              articles[index].title!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                        if (articles[index].description != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              articles[index].description!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),

                        //link

                        if (articles[index].url != null)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextButton(
                              onPressed: () {
                                _launchURLApp(articles[index].url!);
                              },
                              child: const Text(
                                'HABERE GİT >>',style: TextStyle(fontSize: 16),),
                            ),
                          ),
                      ],
                    ));
              })),
    );
  }
}
