import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todoS = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todoS = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text(
                'Lista de Tarefas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff690B22),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: todoController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff690B22),
                                    width: 2,
                                  ),
                                ),
                                labelText: 'Adicione uma tarefa',
                                labelStyle: TextStyle(
                                  color: Color(0xff690B22),
                                ),
                                hintText: 'Ex.: Estudar Flutter',
                                errorText: errorText,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              String text = todoController.text;
                              if (text.isEmpty) {
                                setState(() {
                                  errorText = 'A tarefa não pode ser vazia!';
                                });
                                return;
                              }
                              setState(() {
                                Todo newTodo = Todo(
                                  title: text,
                                  dateTime: DateTime.now(),
                                );
                                todoS.add(newTodo);
                                errorText = null;
                              });
                              todoController.clear();
                              todoRepository.saveTodoList(todoS);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff690B22),
                                padding: const EdgeInsets.all(18)),
                            child: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (Todo todo in todoS)
                              TodoListItem(
                                todo: todo,
                                onDelete: onDelete,
                                finished: finished,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                'Você possui ${todoS.length} tarefas pendentes'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          ElevatedButton(
                            onPressed: showDeleteWtConfirmation,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff690B22),
                              padding: const EdgeInsets.all(18),
                            ),
                            child: const Text('Limpar tudo'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeAll() {
    setState(() {
      todoS.clear();
    });
    todoRepository.saveTodoList(todoS);
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todoS.indexOf(todo);

    setState(() {
      todoS.remove(todo);
    });
    todoRepository.saveTodoList(todoS);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa "${todo.title}" foi removida com sucesso!'),
      backgroundColor: Color(0xff690B22),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            todoS.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todoS);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void showDeleteWtConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xffCEBBBB),
        title: Text('Limpar tudo?'),
        content:
            Text('Você tem certeza que deseja apagar todas as suas tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Color(0xff690B22),
            ),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              removeAll();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Color(0xff690B22),
            ),
            child: Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }

  void finished(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todoS.indexOf(todo);

    setState(() {
      todoS.remove(todo);
    });
    todoRepository.saveTodoList(todoS);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Tarefa "${todo.title}" foi concluida com sucesso!'),
      backgroundColor: Color(0xff690B22),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Desfazer',
        onPressed: () {
          setState(() {
            todoS.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todoS);
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }
}
