import 'package:alexa_app/services/Users.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:alexa_app/services/Musics.dart";
import 'package:localstorage/localstorage.dart';

class Playlist extends StatefulWidget {
  @override
  _PlaylistState createState() => _PlaylistState();
}



CurrentUser user;
List musics;
String name;
LocalStorage storage = LocalStorage("ava");

class _PlaylistState extends State<Playlist> {

  add_music(String name) async{
    await user.add_musik(name, storage);
    await user.get_playlist(storage);
    setState(() {});
  }

  delete_music(int id) async{
    await user.delete_musik(id.toString(), storage);
    await user.get_playlist(storage);
    setState(() {});
  }

  addMusicDialog(BuildContext buildContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add a new song",
              style: TextStyle(color: Color(0xff760F83)),
            ),
            content: Theme(
              data: ThemeData(primaryColor: Color(0xff760F83)),
              child: TextField(
                onChanged: (e){
                  setState(() {
                    name = e.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff760F83)),
                    ),
                    hintText: "Music name",
                    prefixIcon: Icon(Icons.music_note)),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  add_music(name);
                  Navigator.pop(context);
                },
                child: Text("Add"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff760F83)),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context).settings.arguments;
    musics = user.playlist;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.library_music,
          color: Colors.black,
        ),
        onPressed: () {
          addMusicDialog(context);
        },
      ),
      backgroundColor: Color(0xffC4C4C4),
      appBar: AppBar(
        title: Text("My Playlist"),
        centerTitle: true,
        backgroundColor: Color(0xff760F83),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: musics.length,
          itemBuilder: (context, index) {
            // Music instance = musics[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            musics[index]["music"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          delete_music(musics[index]["id"]);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
