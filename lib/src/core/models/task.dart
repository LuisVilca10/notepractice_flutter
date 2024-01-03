import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepat/src/core/constants/parameters.dart';

StateTask convertState(String value) {
  return StateTask.values.firstWhere((element) => element.toString() == value);
}

class Task {
  String? title;
  String? description;
  String? date;
  StateTask state;
  String? id;

  Task({
    this.title,
    this.description,
    this.date,
    this.state = StateTask.Create,
    this.id
  });

  factory Task.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot, String id) {
    return Task(
        title: snapshot["title"],
        description: snapshot["description"],
        date: snapshot["date"],
        state: convertState(snapshot["state"]),
        id: id);
  }
}

Task task = Task(
    title: "Realizar compras",
    description: "Esta es una tarea",
    date: "12-12-2021");
Task task2 = Task(
    title: "Realizar compras",
    description: "Esta es una tarea",
    date: "14-12-2021",
    state: StateTask.Done);
Task task3 = Task(
    title: "Realizar compras",
    description: "Esta es una tarea",
    date: "16-12-2021",
    state: StateTask.PastDate);

List<Task> tasks = [task, task2, task3];