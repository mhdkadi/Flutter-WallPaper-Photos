import 'package:flutter/material.dart';
import 'package:wallpaperflutter/services.dart';
import 'package:wallpaperflutter/data/data.dart';
import 'package:wallpaperflutter/widget/widget.dart';

class SearchView extends StatefulWidget {
  final String search;

  SearchView({@required this.search});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List photos = [];
  int page = 1;
  TextEditingController searchController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  ApiServices apiServices = new ApiServices();

  @override
  void initState() {
    searchController.text = widget.search;
    apiServices
        .getSearchPhotos(page, apiKEY, searchController.text)
        .then((value) {
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
            .getSearchPhotos(page, apiKEY, searchController.text)
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: "search wallpapers",
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        apiServices
                            .getSearchPhotos(
                                page, apiKEY, searchController.text)
                            .then((value) {
                          setState(() {
                            photos = value;
                          });
                        });
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              wallPaper(photos, context),
            ],
          ),
        ),
      ),
    );
  }
}
