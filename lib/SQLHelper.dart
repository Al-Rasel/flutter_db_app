final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDateTime = 'date_time';

class Todo {
  int id;
  String title;
  String dateTime;

  Todo(this.id, this.title, this.dateTime);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnTitle: title,
      columnDateTime: dateTime,
    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    dateTime = map[columnDateTime];
  }
}
