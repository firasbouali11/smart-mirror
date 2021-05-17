import 'dart:io';

import 'package:alexa_app/services/Mails.dart';
import 'package:alexa_app/services/Musics.dart';
import 'package:alexa_app/services/Tasks.dart';
import 'package:localstorage/localstorage.dart';
import "dart:convert";
import "package:http/http.dart";
import "package:alexa_app/constants.dart";

class Admin{
  List users;

  Admin();


  Future<void> get_users(LocalStorage storage) async {
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/users/");
    Map<String,String> headers = {"authorization":"token $token"};
    await get(url,headers: headers).then((value) => this.users = jsonDecode(value.body));
    print(this.users);
  }

  Future<void> create_user(String username, String email,String password,String mirror,File image,LocalStorage storage) async {
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/users/");
      Map<String,String> headers = {"authorization":"token $token"};
      var request = MultipartRequest("POST",url);
      request.headers.addAll(headers);
      request.fields.addAll({
        "username":username,
        "password":password,
        "email":email,
        "mirror_id":mirror,
      });

      request.files.add(await MultipartFile.fromPath("image",image.path));

      var response = await request.send();
  }

  Future<void> delete_user(String id,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/users/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await delete(url,headers: headers);
  }

}

class CurrentUser{
  String id;
  String username;
  String email;
  String image;
  List emails;
  List tasks;
  List playlist;
  Map a;
  List b;


  CurrentUser();

  Future<void> get_user_data(LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/users/getUserData/");
    Map<String,String> headers = {"authorization":"token $token"};
    await get(url,headers: headers).then((value) => a = jsonDecode(value.body));
    this.id=a["id"].toString();
    this.username=a["username"];
    this.email=a["email"];
    this.image=ENDPOINT+a["image"];
  }

  Future<void> get_playlist(LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/musics/");
    Map<String,String> headers = {"authorization":"token $token"};
    await get(url,headers: headers).then((value) => b = jsonDecode(value.body));
    this.playlist = b;
  }

  Future<void> get_tasks(LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/tasks/");
    Map<String,String> headers = {"authorization":"token $token"};
    await get(url,headers: headers).then((value) => b = jsonDecode(value.body));
    this.tasks = b;
  }
  Future<void> get_mails(LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/emails/");
    Map<String,String> headers = {"authorization":"token $token"};
    await get(url,headers: headers).then((value) => b = jsonDecode(value.body));
    this.emails = b;
  }

  Future<void> create_task(String name,String date,LocalStorage storage) async {
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/tasks/");
    Map<String,String> headers = {"authorization":"token $token"};
    await post(url,headers: headers,body: {
      "task":name,
      "date":date,
    });
  }
  Future<void> delete_task(String id,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/tasks/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await delete(url,headers: headers);
  }

  Future<void> add_musik(String name,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/musics/");
    Map<String,String> headers = {"authorization":"token $token"};
    await post(url,headers: headers,body: {
      "music":name,
    });
  }

  Future<void> update_task(String id,bool done,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/tasks/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await patch(url,headers: headers,body: {
      "done": done.toString(),
    });
  }

  Future<void> delete_musik(String id,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/musics/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await delete(url,headers: headers);
  }

  Future<void> add_email(String name,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/emails/");
    Map<String,String> headers = {"authorization":"token $token"};
    await post(url,headers: headers,body: {
      "email":name,
    }).then((value) => a = jsonDecode(value.body));
  }

  Future<void> delete_email(String id,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/emails/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await delete(url,headers: headers);
  }

  Future<void> update_email(String id,bool selected,LocalStorage storage) async{
    String token = storage.getItem("token");
    var url = Uri.parse(ENDPOINT+"/emails/$id/");
    Map<String,String> headers = {"authorization":"token $token"};
    await patch(url,headers: headers,body: {
      "selected": selected.toString(),
    });
  }


}