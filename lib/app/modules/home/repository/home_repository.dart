import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/core/firebase_const.dart';
import 'package:todo_list/app/model/list.dart';
import 'package:todo_list/app/model/todo.dart';
import 'package:todo_list/app/model/user.dart';

class HomeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore dataBase = FirebaseFirestore.instance;

  ///Lista tarefas
  Stream<QuerySnapshot> todoList(bool descending, Map dados) {
    return dataBase
        .collection("task")
        .doc(dados["idUser"])
        .collection(dados["name"])
        .orderBy("timestamp", descending: descending)
        .snapshots();
  }

  ///Dados da lista
  Future<List<QueryDocumentSnapshot>> listData() async {
    List<QueryDocumentSnapshot> list = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await dataBase.collection("list").get();

    for (var dados in snapshot.docs) {
      list.add(dados);
    }
    return list;
  }

  ///Adicionar lista
  void addList(TodoListModel list) {
    list.idList = dataBase.collection("list").doc().id;
    dataBase.collection("list").doc(list.idList).set(list.toMap());
  }

  ///Deletar lista
  void deleteList(TodoListModel list) {
    dataBase.collection("list").doc(list.idList).delete();
  }

  // ///Deletar importado
  // Future<bool> deleteImported(TodoListModel list, String idUser) async {
  //   var dados = await dataBase.collection("list").doc(list.idList).get();
  //   if (dados.exists) {
  //     list = TodoListModel.fromMap(dados.data() as Map);
  //     list.idImported!.remove(idUser);
  //     dataBase.collection("list").doc(list.idList).update(list.toMap());
  //     return true;
  //   }
  //   return false;
  // }

  // ///Importar lista
  // Future<bool> importList(String idList, String idUser) async {
  //   TodoListModel listModel = TodoListModel();
  //   var dados = await dataBase.collection("list").doc(idList).get();
  //   if (dados.exists) {
  //     listModel = TodoListModel.fromMap(dados.data() as Map);
  //     listModel.idImported!.add(idUser);
  //     dataBase.collection("list").doc(idList).update(listModel.toMap());
  //     return true;
  //   }
  //   return false;
  // }

  ///Adicionar todoList
  void addTodoList(TodoTaskModel todo) {
    String idDoc = dataBase.collection("task").doc().id;
    todo.idTodoList = idDoc;
    dataBase
        .collection("task")
        .doc(todo.idUser)
        .collection(todo.taskName)
        .doc(idDoc)
        .set(todo.toMap());
  }

  ///Editar todoList
  void editTodoList(TodoTaskModel todo) {
    dataBase
        .collection("task")
        .doc(todo.idUser)
        .collection(todo.taskName)
        .doc(todo.idTodoList)
        .update(todo.toMap());
  }

  ///Deletar todoList
  void deleteTodoList(TodoTaskModel todo) {
    dataBase
        .collection("task")
        .doc(todo.idUser)
        .collection(todo.taskName)
        .doc(todo.idTodoList)
        .delete();
  }

  ///Atualizar todoList
  void updateTodoList(TodoTaskModel todo) {
    dataBase
        .collection("task")
        .doc(todo.idUser)
        .collection(todo.taskName)
        .doc(todo.idTodoList)
        .update({"check": todo.check});
  }

  ///Recuperar dados do usuário:
  Future recoverUserData() async {
    User user = _auth.currentUser!;
    UserModel userModel = UserModel();
    DocumentSnapshot snapshot =
        await dataBase.collection(FirebaseConst.usuarios).doc(user.uid).get();
   print('asdfasdf');
   print(user.uid);
   print(snapshot.data());
    userModel = UserModel.fromMap(snapshot.data() as Map);
    return userModel;
  }

  ///Verificar o usuário atual:
  bool checkCurrentUser() {
    User? user = _auth.currentUser;
    return user != null ? true : false;
  }
}
