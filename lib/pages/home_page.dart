import 'package:flutter/material.dart';
import 'package:flutter_tasklist_app/data/datasource/task_remote_datasource.dart';
import 'package:flutter_tasklist_app/data/models/task_response_model.dart';
import 'package:flutter_tasklist_app/pages/add_task_page.dart';
import 'package:flutter_tasklist_app/pages/detail_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;

  List<Task> tasks = [];

  Future<void> getTask() async {
    setState(() {
      isLoaded = true;
    });

    final model = await TaskRemoteDatasource().getTasks();
    tasks = model.data;

    setState(() {
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTask();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List', style: TextStyle(color: Colors.white),),
        elevation: 2,
        backgroundColor: Colors.blue,
      ),
      body:
      isLoaded ? const Center(child: CircularProgressIndicator(),) :
      ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              bool isTaskDeleted = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailTaskPage(
                  task: tasks[index],
                );
              }));
              if (isTaskDeleted) {
                // Reload tasks
                getTask();
              }
            },
            child: Card(
              child: ListTile(
                title: Text(tasks[index].attributes.title),
                subtitle: Text(tasks[index].attributes.description),
                trailing: const Icon(Icons.check_circle),
              ),
            ),
          );
        },
        itemCount: tasks.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isTaskAdded = await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTaskPage();
          }));

          if (isTaskAdded) {
            // Reload tasks
            getTask();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}