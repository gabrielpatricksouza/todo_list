import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:todo_list/app/model/list.dart';
import 'package:todo_list/app/model/todo.dart';
import 'package:todo_list/app/model/user.dart';
import 'package:todo_list/app/modules/home/repository/home_repository.dart';
import 'package:todo_list/app/widgets/alert.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final HomeRepository _repository = HomeRepository();
  TextEditingController textController = TextEditingController();

  ///Buscar tarefas
  fetchTasks(Map dados) => _repository.todoList(descending, dados);

  ///Lista de tarefas do usuário
  @observable
  ObservableList<TodoListModel> userTodoList = ObservableList<TodoListModel>();

  @observable
  bool imported = false;

  @observable
  bool loading = false;

  ///Buscar lista
  @action
  searchList() async {
    loading = true;

    if (userModel.name.isNotEmpty) {
      TodoListModel listModel = TodoListModel();
      List<QueryDocumentSnapshot> list = [];
      list = await _repository.listData();

      for (var dados in list) {
        listModel = TodoListModel.fromMap(dados.data() as Map);

        if (userModel.idUser == listModel.idUser ||
            listModel.idImported!
                .contains(userModel.idUser)) {
          userTodoList.add(listModel);
        }
      }
      loading = false;
    } else {
      await recoverUserData();
      searchList();
    }
  }

  @observable
  bool descending = false;

  ///Mudar ordem
  @action
  changeOrder(Map dados) {
    descending = !descending;
    fetchTasks(dados);
  }

  TodoTaskModel convertTodoList(DocumentSnapshot dados) {
    return TodoTaskModel.fromMap(dados.data() as Map);
  }

  @observable
  int count = 0;
  ///Adicionar lista

  @action
  setCount(int value)=> count = value;

  @action
  Future addList() async {
    if (userModel.idUser.isNotEmpty) {
      TodoListModel listModel = TodoListModel();
      listModel.name = textController.text;
      listModel.idUser = userModel.idUser;
      textController.text = "";

      _repository.addList(listModel);
      userTodoList.clear();
      searchList();
    } else {
      print('sem user id');
      await recoverUserData();
    }
    Modular.to.pop();
    print('ERRO AQUI');
  }

  ///Deletar lista
  void deleteList(TodoListModel listModel) {
    if (userModel.idUser == listModel.idUser) {
      _repository.deleteList(listModel);
    }
    // else if (listModel.idImported!.isNotEmpty) {
    //   _repository.deleteImported(listModel, userModel.idUser);
    // }
  }

  // ///Importar lista
  // void importList(context) async {
  //   if (userModel.idUser.isNotEmpty) {
  //     bool response = await _repository.importList(
  //         textController.text, userModel.idUser);
  //     if (response == false) {
  //       alertDialog(context, AlertType.info, "ATENÇÃO",
  //           "Preencha todos os campos para prosseguirmos!");
  //     } else {
  //       userTodoList.clear();
  //       searchList();
  //       Modular.to.pop();
  //     }
  //   } else {
  //     recoverUserData();
  //     Modular.to.pop();
  //   }
  // }

  ///Adicionar tarefa
  void addTask(TodoTaskModel taskModel) {
    taskModel.task = textController.text;
    taskModel.timestamp = Timestamp.now();
    textController.text = "";

    _repository.addTodoList(taskModel);
    Modular.to.pop();
  }

  ///Editar tarefa
  void editTask(TodoTaskModel taskModel) {
    taskModel.task = textController.text;
    textController.text = "";

    _repository.editTodoList(taskModel);
    Modular.to.pop();
  }

  ///Deletar tarefa
  void deleteTask(TodoTaskModel taskModel) {
    _repository.deleteTodoList(taskModel);
  }

  ///Atualizar
  void updateTodoList(TodoTaskModel taskModel) {
    _repository.updateTodoList(taskModel);
  }

  ///Manipular texto
  void manipulateText(String text) {
    textController.text = text;
  }

  @observable
  UserModel userModel = UserModel();

  @action
  recoverUserData() async {
    bool response = _repository.checkCurrentUser();
    if(response) {
      userModel = await _repository.recoverUserData();
    }
  }

  @action
  clearVariables() {
    userModel = UserModel.clean();
  }
}