import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperflutter/data/data.dart';
import 'package:wallpaperflutter/view/categorie_screen.dart';
import 'package:wallpaperflutter/view/search_view.dart';
import 'package:wallpaperflutter/widget/widget.dart';
import 'package:wallpaperflutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories;
  int page = 1;
  List photos = [];
  ApiServices apiServices = new ApiServices();
  TextEditingController searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    apiServices.getTrendingPhotos(page, apiKEY).then((value) {
      setState(() {
        photos = value;
      });
    });
    categories = getCategories;
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        apiServices.getTrendingPhotos(page, apiKEY).then((value) {
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: <Widget>[
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
                    )),
                    InkWell(
                      onTap: () {
                        if (searchController.text != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchView(
                                search: searchController.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 80,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                        imgUrls: categories[index]['imageURL'],
                        categorie: categories[index]['categorieName'],
                      );
                    }),
              ),
              Text(
                "Discover new photos",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Overpass',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 14,
              ),
              wallPaper(photos, context),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  CategoriesTile({@required this.imgUrls, @required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorieScreen(
              categorie: categorie,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imgUrls,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              height: 50,
              width: 100,
              alignment: Alignment.center,
              child: Text(
                categorie ?? "Loading",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Overpass'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
