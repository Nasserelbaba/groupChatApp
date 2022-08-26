import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  static const String screenRoute = 'full_Screen';
  FullScreenImage({this.imageurl, Key? key}) : super(key: key);
  final imageurl;
  double x = 12.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      /*  appBar: AppBar(
        title: Center(
            child: Container(
                padding: EdgeInsets.only(right: 50),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20),
                ))),
      ), */
      /* backgroundColor: Colors.black, */
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Hero(
          tag: 'imageHero',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 8,
            child: CachedNetworkImage(
              imageUrl: imageurl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
