import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map?todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isEdit=false;
  @override
  void initState() {
   
    super.initState();
    final todo=widget.todo;
    if(todo !=null){
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titlecontroller.text=title;
      descriptioncontroller.text=description;

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(isEdit? 'Edit Todo' : 'Add Todo',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titlecontroller,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed:isEdit?updateData: submitData ,
            child:  Text(isEdit?'Update' :'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> updateData()async {
    final todo=widget.todo;
    if(todo==null){
      //print('you cannot call updated without todo data');
      return;
    }
    final id=todo['_id'];
   // final isCompleted=todo['is_completed'];
     final title = titlecontroller.text;
    final description = descriptioncontroller.text;

    final body = {
      
        "title": title,
        "description": description,
        "is_completed": false,
      
    };
    //submit data to the server
     final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      
      successMessage('Updation Success');
    } else {
      errorMessage('Updation Failed');
      
    }
  }

  Future<void> submitData() async {
    //get the data from form

    final title = titlecontroller.text;
    final description = descriptioncontroller.text;

    final body = {
      
        "title": title,
        "description": description,
        "is_completed": false,
      
    };
    //submit data to the server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      titlecontroller.text='';
      descriptioncontroller.text='';
      successMessage('Creation Success');
    } else {
      errorMessage('Creation Failed');
      
    }

    //show success or fail message based on status
  }


  void successMessage(String message){
    final snackBar=SnackBar(content: Text(message),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
   void errorMessage(String message){
    final snackBar=SnackBar(content: Text(message,style: const TextStyle(color: Colors.black),),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
