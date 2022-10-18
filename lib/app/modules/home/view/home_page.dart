import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:share/share.dart';
import 'package:todo_list/app/modules/home/store/home_store.dart';
import 'package:todo_list/app/modules/home/view/add_task_list.dart';
import 'package:todo_list/generated/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeStore controller = Modular.get();

  @override
  void initState() {
    controller.recoverUserData();
    controller.searchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkPurple,
      appBar: AppBar(
        title: const Text(
          'LISTA DE TAREFAS',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightPurple,
          ),
        ),
        centerTitle: true,
        backgroundColor: purple,
        elevation: 2.0,
        iconTheme: const IconThemeData(
          color: lightPurple,
        ),
        // leading: IconButton(
        //   onPressed: () {
        //     controller.manipulateText("");
        //     showDialog(
        //       context: context,
        //       builder: (_) => AddTaskList(
        //         action: "Importar",
        //         controller: controller,
        //         hintText: "Código",
        //         buttomText: "Utilizar",
        //       ),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.download_rounded,
        //   ),
        // ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Modular.to.navigate('/login');
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Observer(
        builder: (_) => controller.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: lightPurple,
                ),
              )
            : controller.userTodoList.isEmpty
                ? const Center(
                    child: Text(
                      "Sem Lista",
                      style: TextStyle(
                        fontSize: 25,
                        color: lightPurple,
                      ),
                    ),
                  )
                : NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (
                      OverscrollIndicatorNotification overscroll,
                    ) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: controller.userTodoList.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: lightPurple,
                            child: Dismissible(
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                controller.deleteList(
                                  controller.userTodoList[index],
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.delete_forever_outlined,
                                  ),
                                ),
                              ),
                              key: ValueKey(
                                controller.userTodoList.length,
                              ),
                              child: ListTile(
                                title: Text(
                                  controller.userTodoList[index].name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                // trailing: IconButton(
                                //   onPressed: () {
                                //     Share.share(
                                //       'Código para importação:  ${controller.userTodoList[index].idList}',
                                //     );
                                //   },
                                //   icon: const Icon(
                                //     Icons.share_rounded,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                onTap: () {
                                  Modular.to
                                      .pushNamed("/home/todoList", arguments: {
                                    'name': controller.userTodoList[index].name,
                                    'idUser':
                                        controller.userTodoList[index].idUser,
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.manipulateText('');
          showDialog(
            context: context,
            builder: (_) => AddTaskList(
              action: 'Adicionar lista',
              controller: controller,
              hintText: 'Título da tarefa',
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

