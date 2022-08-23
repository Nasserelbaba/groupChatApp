import 'package:chatapp/services/firebaseServices.dart';
import 'package:chatapp/services/google_auth.dart';
import 'package:chatapp/view/message_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'welcome_screen.dart';

final _firestrore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

//for images
ImagePicker _picker = ImagePicker();
XFile? image;
int uploading = 0;

//
class _ChatScreenState extends State<ChatScreen> {
  //for images
  //firebase storage crud
  String imageurl = '';
  String date = '';
  double _progress = 0;
  /*  firebase_storage.UploadTask? _uploadTasks; */
  firebase_storage.Reference? reference;
  Future<firebase_storage.UploadTask?> uploadFile(PickedFile file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }
    setState(() {
      uploading = 1;
    });
    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images")
        .child(date + image!.name);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(file.path), metadata);
      uploadTask = ref.putFile(io.File(file.path));
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double _progress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });
      uploadTask.snapshotEvents.listen((TaskSnapshot event) {
        setState(() {
          _progress = event.bytesTransferred / event.totalBytes;

          print("this is your progress :${_progress * 100}");
        });
      }).onError((error) {
        print("your image didnt upload the error is $error");
      });
      /* uploadTask.events.listen((event) {
        setState(() {
          _progress = event.snapshot.bytesTransferred.toDouble() /
              event.snapshot.totalByteCount.toDouble();
        });
      }).onError((error) {
        // do something to handle error
      });
      LinearProgressIndicator(
        value: _progress,
      ); */
      var dowurl =
          await (await uploadTask /* .whenComplete(() => print("object")) */)
              .ref
              .getDownloadURL();
      String url = dowurl.toString();
      setState(() {
        imageurl = url;
        uploading = 0;
      });
    }
    return Future.value(uploadTask);
  }

  Widget pickedimagewidget() {
    return GestureDetector(
      onTap: () async {
        image = await _picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      child: Container(
        child: Center(
          child: image != null
              ? Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 6,
                  child: Image.file(
                    io.File("${image!.path}"),
                    fit: BoxFit.fill,
                  ),
                )
              : Icon(Icons.attach_file),
        ),
      ),
    );
  }

  //
  final _auth = FirebaseAuth.instance;
  final messageController = TextEditingController();
  String? messageText;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Expanded(child: Container()),
            Text(
              'GroupChat',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              signOutGoogle();
              Navigator.pop(context);
              Navigator.pushNamed(context, WelcomeScreen.screenRoute);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  pickedimagewidget(),
                  uploading == 0
                      ? TextButton(
                          onPressed: () async {
                            //for image
                            if (image != null) {
                              PickedFile file = PickedFile(image!.path);
                              if (file != null) {
                                setState(() {
                                  date = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                });
                                await uploadFile(file);
                              }
                            }
                            //
                            await _firestrore.collection("messages").add({
                              "text": messageText,
                              "sender": context
                                  .read<AuthenticationService>()
                                  .getemail(),
                              'time': FieldValue.serverTimestamp(),
                              "imageUrl": image != null ? imageurl : null
                            });
                            messageController.clear();
                            image = null;
                            _progress = 0;
                            setState(() {});
                            /*    uploadFile(file); */
                          },
                          child: Text(
                            'send',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : CircularProgressIndicator()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestrore.collection("messages").orderBy("time").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<MessageLine> messagesWidgets = [];
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message["text"];
          final sender = message["sender"];
          final time = message["time"];
          final imageUrl = message["imageUrl"];
          final currentuser = context.read<AuthenticationService>().getemail();
          final messageWidget = MessageLine(
              text: messageText,
              sender: sender,
              time: time,
              isMe: currentuser == sender,
              imageUrl: imageUrl);
          messagesWidgets.add(messageWidget);
        }
        return Expanded(
            child: ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: messagesWidgets,
        ));
      },
    );
  }
}
