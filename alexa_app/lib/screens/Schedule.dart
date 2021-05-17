import 'package:alexa_app/services/Users.dart';
import "package:flutter/material.dart";
import "package:alexa_app/services/Tasks.dart";
import 'package:localstorage/localstorage.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

CurrentUser user;
List tasks;
String name;
LocalStorage storage = LocalStorage("ava");


class _ScheduleState extends State<Schedule> {
  DateTime pickedDate = DateTime.now();

  pickdate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate:pickedDate,
        firstDate: DateTime(DateTime.now().year-5),
        lastDate: DateTime(DateTime.now().year+5),
    );
    if (date != null){
      setState(() {
        pickedDate = date;
      });
    }
  }

  create_task(String name,String date) async {
    await user.create_task(name, date, storage);
    await user.get_tasks(storage);
    setState(() {});
  }

  delete_task(int id) async {
    await user.delete_task(id.toString(), storage);
    await user.get_tasks(storage);
    setState(() {});
  }

  update_task(int id,bool done) async {
    await user.update_task(id.toString(),done, storage);
    await user.get_tasks(storage);
    setState(() {});
  }


  addTaskDialog(BuildContext buildContext) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Add a new task",
              style: TextStyle(color: Color(0xff760F83)),
            ),
            content: Container(
              alignment: Alignment.bottomLeft,
              height: 120,
              child: Column(
                children: [
                  Theme(
                    data: ThemeData(primaryColor: Color(0xff760F83)),
                    child: TextField(
                      onChanged: (e){
                        name = e.toLowerCase();
                      },
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff760F83)),
                          ),
                          hintText: "Task Name",
                          prefixIcon: Icon(Icons.cancel_schedule_send)),
                    ),
                  ),
                  ListTile(
                    title: Text("${pickedDate.day.toString()} - ${pickedDate.month.toString()} - ${pickedDate.year.toString()}"),
                    trailing: Icon(Icons.arrow_drop_down_sharp,color: Colors.black,),
                    onTap: (){pickdate();}
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  String date = "${pickedDate.year.toString()}-${pickedDate.month.toString()}-${pickedDate.day.toString()}";
                  create_task(name, date);
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
    bool a = true;
    user = ModalRoute.of(context).settings.arguments;
    tasks = user.tasks;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.schedule, color: Colors.black,),
        onPressed: () {
          addTaskDialog(context);
        },
      ),
      backgroundColor: Color(0xffC4C4C4),
      appBar: AppBar(
        title: Text("My tasks"),
        centerTitle: true,
        backgroundColor: Color(0xff760F83),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            // Task instance = tasks[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tasks[index]["task"], style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),),
                          Text(tasks[index]["date"], style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13
                          ),),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(value: tasks[index]["done"],
                              onChanged: (bool newval) {
                                update_task(tasks[index]["id"], newval);
                              }),
                          TextButton(
                            onPressed: () {
                              delete_task(tasks[index]["id"]);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent),
                            ),
                            child: Icon(Icons.delete, color: Colors.black,),
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

