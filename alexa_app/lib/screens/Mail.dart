import 'package:alexa_app/services/Users.dart';
import "package:flutter/material.dart";
import "package:alexa_app/services/Mails.dart";
import 'package:localstorage/localstorage.dart';

class Mailing extends StatefulWidget {
  @override
  _MailingState createState() => _MailingState();
}

CurrentUser user;
List mails;
String name;
LocalStorage storage = LocalStorage("ava");
class _MailingState extends State<Mailing> {

  add_email(String name)async{
    await user.add_email(name, storage);
    await user.get_mails(storage);
    setState(() {});
  }

  delete_email(int id) async{
    await user.delete_email(id.toString(), storage);
    await user.get_mails(storage);
    setState(() {});
  }

  update_email(int id,bool selected) async {
    await user.update_email(id.toString(), selected, storage);
    await user.get_mails(storage);
    setState(() {});
  }
  addMailDialog(BuildContext buildContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add a new email",
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
                    hintText: "email name",
                    prefixIcon: Icon(Icons.email)),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  add_email(name);
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
    mails = user.emails;
    bool a = false;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.library_music,
          color: Colors.black,
        ),
        onPressed: () {
          addMailDialog(context);
        },
      ),
      backgroundColor: Color(0xffC4C4C4),
      appBar: AppBar(
        title: Text("My Emails"),
        centerTitle: true,
        backgroundColor: Color(0xff760F83),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: mails.length,
          itemBuilder: (context, index) {
            // Mail instance = mails[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mails[index]["email"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.,
                        children: [
                          Checkbox(value: mails[index]["selected"], onChanged: (newval){
                            update_email(mails[index]["id"], newval);
                          }),
                          TextButton(
                            onPressed: () {
                              delete_email(mails[index]["id"]);
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
