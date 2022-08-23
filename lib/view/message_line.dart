import 'package:chatapp/view/chatList.dart';
import 'package:chatapp/view/full_screen_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class MessageLine extends StatelessWidget {
  const MessageLine(
      {this.sender, this.text, this.time, this.isMe, this.imageUrl, Key? key})
      : super(key: key);
  final String? sender;
  final String? text;
  final bool? isMe;
  final Timestamp? time;
  final String? imageUrl;

  Future<void> downloadingImage(String url) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      /*     var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId); */
    } on PlatformException catch (error) {
      print("error$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment:
              isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text("$sender"),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                  topLeft: isMe! ? Radius.circular(30) : Radius.circular(0),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topRight: isMe! ? Radius.circular(0) : Radius.circular(30)),
              color: isMe! ? Colors.blue[800] : Colors.orange,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    imageUrl != null
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            /* height: MediaQuery.of(context).size.width / 2, */
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: isMe!
                                      ? Radius.circular(30)
                                      : Radius.circular(0),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  topRight: isMe!
                                      ? Radius.circular(0)
                                      : Radius.circular(30)),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return FullScreenImage(
                                          imageurl: imageUrl!,
                                        );
                                      }));
                                    },
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fitWidth,
                                      imageUrl: imageUrl!,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                                  child: Column(children: [
                                        SizedBox(
                                          height: 100,
                                        ),
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                        SizedBox(
                                          height: 100,
                                        )
                                      ])),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await downloadingImage(imageUrl!);
                                        var snackBar = SnackBar(
                                          content: Text(
                                              'image has been downloaded!'),
                                        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      },
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.download,
                                          size: 30,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: 1,
                          ),
                    text != null
                        ? Text(
                            '$text',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )
                        : Container(
                            child: SizedBox(height: 1),
                          ),
                    time != null
                        ? Text(
                            '${time!.toDate().hour}:${time!.toDate().minute}',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          )
                        : Container(
                            child: CircularProgressIndicator(),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
