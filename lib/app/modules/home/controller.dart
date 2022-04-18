import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:getx_todo_list/app/data/services/storage/repository.dart';

import '../../data/models/task.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  // criando nossa chave de formulario para controlar o estado
  final formKey = GlobalKey<FormState>();

  // criando controlador do campo de texto do formulario
  final editCtrl = TextEditingController();

  // criando controle para tabs, observável
  final tabIndex = 0.obs;

  // criando um index para controlar o ícone selecionado obserável
  // o padrão é zero, para toda vez primeira vez que o dialogo for aberto ele mostra
  // o primeiro icone do array como selecionado
  final chipIndex = 0.obs;

  final deleting = false.obs;

  // pegando a lista de tarefas com observable para capturar os dados atualizados
  // a cada modificação
  final tasks = <Task>[].obs;

  // criando a tarefa com valor dinamico inicial
  final task = Rx<Task?>(null);

  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    // ao iniciar acessamos o repoositpry para requisitar a listagem de tarefas
    tasks.assignAll(taskRepository.readTasks());

    // usando ever para sempre que a lista mudar ele reescrever via repository
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();
  }

  // função para seleção da tab
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // função para setar o icone selecionado pelo usuario
  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  // motando as listas de todos doing e done
  void changeTodos(List<dynamic> select) {
    doingTodos.clear(); // limpando a lista
    doneTodos.clear(); // limpaando a lista
    for (int i = 0; i < select.length; i++) {
      // capturando cada todo da listagem
      var todo = select[i];
      // acessando o atributo done da task
      // para verificar o status
      var status = todo['done'];
      if (status == true) {
        // se for done entra na listagem de todo done
        doneTodos.add(todo);
      } else {
        // se não entra na lista de todo doing
        doingTodos.add(todo);
      }
    }
  }

  // método de salvar task
  bool addTask(Task task) {
    // se dentro da lista de tasks
    // esssa task já existir
    // retornamos falso
    if (tasks.contains(task)) {
      return false;
    }

    tasks.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containeTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containeTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
      (element) => mapEquals<String, dynamic>(doingTodo, element),
    );
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos.indexWhere(
      (element) => mapEquals<String, dynamic>(
        doneTodo,
        element,
      ),
    );
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  // método para verificar se os todos estão vazios
  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  // método para pegar a quantidade de todos finalizados
  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  // caputrando o total de tarefas
  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  // capturando o total de tarefas finalizadas
  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
