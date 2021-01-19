import 'package:flutter/material.dart';
import 'package:wallpaperflutter/widget/widget.dart';
import 'package:wallpaperflutter/data/data.dart';
import 'package:wallpaperflutter/services.dart';

class CategorieScreen extends StatefulWidget {
  final String categorie;

  CategorieScreen({@required this.categorie});

  @override
  _CategorieScreenState createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  List photos = [];

  int page = 1;
  ScrollController _scrollController = new ScrollController();
  ApiServices apiServices = new ApiServices();

  @override
  void initState() {
    apiServices.getSearchPhotos(page, apiKEY, widget.categorie).then((value) {
      setState(() {
        photos = value;
      });
    });
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        apiServices
            .getSearchPhotos(page, apiKEY, widget.categorie)
            .then((value) {
          setState(() {
            photos.addAll(value);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Wallpaper",
              style: TextStyle(color: Colors.black87, fontFamily: 'Overpass'),
            ),
            Text(
              "Flutter",
              style: TextStyle(color: Colors.blue, fontFamily: 'Overpass'),
            )
          ],
        ),
        elevation: 0.0,
        actions: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: wallPaper(photos, context),
      ),
    );
  }
}
