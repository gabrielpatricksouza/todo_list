import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_list/app/model/todo.dart';
import 'package:todo_list/app/modules/home/store/home_store.dart';
import 'package:todo_list/app/modules/home/view/add_task_list.dart';
import 'package:todo_list/generated/colors.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
    required this.taskData,
  }) : super(key: key);

  final Map taskData;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final HomeStore controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkPurple,
      appBar: AppBar(
        title: Text(
          widget.taskData['name'],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: lightPurple,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: lightPurple),
        backgroundColor: purple,
        elevation: 2.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Observer(
              builder: (_) => IconButton(
                onPressed: () => setState(
                  () => controller.changeOrder(widget.taskData),
                ),
                iconSize: 28,
                color: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                icon: Icon(
                  controller.descending
                      ? Icons.arrow_circle_up_rounded
                      : Icons.arrow_circle_down_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: controller.fetchTasks(widget.taskData),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Container(
                color: lightPurple,
                child: const Center(
                  child: Text(
                    "Ocorreu um erro ao carregar lista!",
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: purple,
                ),
              );
            } else {
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    height: 10,
                    color: Colors.white,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    TodoTaskModel taskModel = controller.convertTodoList(
                      snapshot.data!.docs[index],
                    );

                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        taskModel.idUser = widget.taskData["idUser"];
                        taskModel.taskName = widget.taskData["name"];
                        controller.deleteTask(taskModel);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.delete_forever_outlined,
                          ),
                        ),
                      ),
                      key: ValueKey(
                        snapshot.data!.docs.length,
                      ),
                      child: ListTile(
                        title: Text(
                          taskModel.task,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: Checkbox(
                          value: taskModel.check,
                          checkColor: Colors.white,
                          onChanged: (bool? value) {
                            taskModel.check = value!;
                            taskModel.idUser = widget.taskData["idUser"];
                            taskModel.taskName = widget.taskData["name"];
                            controller.updateTodoList(taskModel);
                          },
                        ),
                        onTap: () {
                          taskModel.idUser = widget.taskData["IdUser"];
                          taskModel.taskName = widget.taskData["name"];
                          controller.manipulateText(taskModel.task);
                          showDialog(
                            context: context,
                            builder: (_) => AddTaskList(
                              taskModel: taskModel,
                              action: "Editar",
                              controller: controller,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.manipulateText("");
          TodoTaskModel taskModel = TodoTaskModel();
          taskModel.idUser = widget.taskData['idUser'];
          taskModel.taskName = widget.taskData['name'];
          showDialog(
            context: context,
            builder: (_) => AddTaskList(
              action: "Adicionar",
              controller: controller,
              taskModel: taskModel,
            ),
          );
        },
        backgroundColor: mediumPurple,
        child: const Icon(
          Icons.add,
          size: 30,
          color: darkPurple,
        ),
      ),
    );
  }
}
