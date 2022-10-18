class TodoListModel {
  String idUser;
  String name;
  String idList;
  List? idImported = [];

  TodoListModel({
    this.idUser = '',
    this.name = '',
    this.idList = '',
    this.idImported,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'idUser': idUser,
      'name': name,
      'idList': idList,
      'idImported': idImported,
    };
    return map;
  }

  factory TodoListModel.fromMap(Map<dynamic, dynamic>? dados) {
    return TodoListModel(
      idUser: dados?['idUser'] ?? '',
      name: dados?['name'] ?? '',
      idList: dados?['idList'] ?? '',
      idImported: dados?['taskName'] ?? [],
    );
  }
}
