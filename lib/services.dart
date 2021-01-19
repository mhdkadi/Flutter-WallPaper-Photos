import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  Future getTrendingPhotos(int page, String apiKEY) async {
    List photos = [];
    try {
      await http
          .get(
              "https://api.unsplash.com/photos/?client_id=$apiKEY&per_page=30&page=$page")
          .then((value) {
        List jsonData = jsonDecode(value.body);
        jsonData.forEach((element) {
          photos.add({
            "photographer": element["user"]["name"],
            "portrait": element["urls"]["small"],
            "created_at": element["created_at"],
            "alt_description": element["alt_description"],
            "likes": element["likes"],
            "height": element["height"],
          });
        });
      });
      return photos;
    } catch (error) {
      print("Error Getting Trending Photos: ($error)");
      return [];
    }
  }

  Future getSearchPhotos(int page, String apiKEY, String categorie) async {
    List photos = [];
    try {
      await http
          .get(
              "https://api.unsplash.com/search/photos/?client_id=$apiKEY&query=$categorie&per_page=30&page=$page")
          .then((value) {
        Map<String, dynamic> jsonData = jsonDecode(value.body);
        jsonData["results"].forEach((element) {
          photos.add({
            "photographer": element["user"]["name"],
            "portrait": element["urls"]["small"],
            "created_at": element["created_at"],
            "alt_description": element["alt_description"],
            "likes": element["likes"],
          });
        });
      });
      return photos;
    } catch (error) {
      print("Error Getting Categorie Photos: ($error)");
      return [];
    }
  }
}
