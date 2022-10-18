import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:todo_list/app/model/todo.dart';
import 'package:todo_list/app/modules/home/store/home_store.dart';
import 'package:todo_list/app/widgets/alert.dart';
import 'package:todo_list/generated/colors.dart';

class AddTaskList extends StatelessWidget {
  AddTaskList({
    Key? key,
    required this.action,
    this.hintText = 'Tarefa',
    this.buttomText = 'Salvar',
    required this.controller,
    this.taskModel,
  }) : super(key: key);

  final String action;
  final String hintText;
  final String buttomText;
  final HomeStore controller;
  final TodoTaskModel? taskModel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: lightPurple,
        title: Text(action),
        content: TextFormField(
          //maxLength: action == "Importar" ? 20 : 65,
          maxLength: 65,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return action == "Importar"
                  ? 'Insira o código'
                  : 'Insira uma tarefa';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          cursorColor: purple,
          controller: controller.textController,
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            margin: const EdgeInsets.only(bottom: 10.0),
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (action == "Adicionar") {
                    final task =
                        TodoTaskModel(task: controller.textController.text);
                    if (taskModel == null) {
                      alertDialog(
                        context,
                        AlertType.info,
                        'ATENÇÃO',
                        'Ocorreu um erro ao criar lista',
                      );
                      print('está nullo');
                    }
                    controller.addTask(task);
                  } else if (action == "Lista") {
                    await controller.addList();
                  } else if (action == "Editar") {
                    controller.editTask(taskModel!);
                  }
                  // else if (action == "Importar") {
                  //   controller.importList(context);
                  // }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(purple),
              ),
              child: Text(
                buttomText,
                style: const TextStyle(
                  color: lightPurple,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
