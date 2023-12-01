import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miniproject/models/articlemodel.dart';
import 'package:miniproject/style.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0),
      elevation: 0, // Tingkat elevasi kartu
      // Margin di sekitar kartu
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? "", // URL gambar artikel
                  height: 190, // Tinggi gambar
                  width: 333, // Lebar gambar mengisi seluruh kartu
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey,
                    height: 190,
                    width: 333,
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ), // Mengatur bagaimana gambar mengisi ruang yang tersedia
                ),
              ),
              Text(
                article.createdAt ?? "",
                style: Styles.subheaderTextStyle,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  article.title ?? " ",
                  style: Styles.Text16,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // Button width
                        height: 20, // Button height
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text("Artikel",
                              style: TextStyle(
                                color: Color.fromRGBO(30, 66, 159, 1),
                                fontSize: 8,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              )),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor:
                                  Color.fromRGBO(225, 239, 254, 1)),
                        ),
                      ),
                      Container(
                        // Button width
                        height: 20, // Button height
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text(article.categories![0]["name"] ?? "",
                              style: TextStyle(
                                color: Color.fromRGBO(205, 122, 18, 1),
                                fontSize: 8,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              )),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor:
                                  Color.fromRGBO(254, 250, 236, 1)),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
