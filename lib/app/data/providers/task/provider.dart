import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/keys.dart';
import 'package:getx_todo_list/app/data/models/task.dart';
import 'package:getx_todo_list/app/data/services/storage/services.dart';

class TaskProvider {
  final _storage = Get.find<StorageService>();

  // lendo as tarefas
  List<Task> readTasks() {
    var tasks = <Task>[];
    // consultando os dados de tasks do local storage
    // decodificando json e adicionando a lista de tasks
    // como objeto task usando metodo Task.fromJson
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }

  // escrevendo as tarefas
  void writeList(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
