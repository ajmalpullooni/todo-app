

import 'package:flutter/material.dart';
import 'package:todo_list/screens/add_page.dart';

import 'package:todo_list/utils/snackbar_helper.dart';
import 'package:todo_list/services/todo_service.dart';

import '../widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({
    super.key,
  });

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement:  Center(
              child: Text('No Todo Item',
              style: Theme.of(context).textTheme.headlineSmall,
              ),

            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
               // final id = item['_id'] as String;
                return TodoCard(
                  deleteById: deleteById,
                  index: index,
                  item: item,
                  navigateEdit: naviageteToEditPage,

                );
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: naviageteToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> naviageteToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage();
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> naviageteToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage(todo: item);
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    //delete item from current list
    // final url = 'https://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    // final response = await http.delete(uri);
    final isSuccess= await TodoService.deleteById(id);

    if (isSuccess) {
      //remove item from the  list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      errorMessage(context, message: 'Deletion Failed');
    }
  }

  Future<void> fetchTodo() async {
    // setState(() {
    //   isLoading = true;
    // });
    // final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    // final uri = Uri.parse(url);
    // final response = await http.get(uri);
    final response=await TodoService.fetchTodo();
    if (response!=null) {
       
      setState(() {
        items = response;
      });
    }else{
      errorMessage(context, message: 'Something error wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  // void errorMessage(String message) {
  //   final snackBar = SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: Colors.black),
  //     ),
  //     backgroundColor: Colors.red,
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}
