import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/todo/friend_search_screen.dart';
import 'package:todomate/screens/todo/todo_provider.dart';
import 'package:todomate/screens/todo/todo_create_screen.dart';
import 'package:todomate/screens/todo/todo_edit_screen.dart';


class TodoListScreen extends StatefulWidget {
  final String userId;

  const TodoListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('투두리스트'),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendSearchScreen(userId: widget.userId)),
                );
              },
            ),
          ],
        ),
        body: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            final todos = todoProvider.todos;
            if (todos.isEmpty) {
              return Center(child: Text('투두리스트가 없습니다. 새로운 항목을 추가해보세요!'));
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: Key(todo.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    todoProvider.deleteTodo(todo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} 삭제됨')),
                    );
                  },
                  child: ListTile(
                    title: Text(todo.title),
                    subtitle: Text('${todo.startDate.toString().split(' ')[0]} - ${todo.endDate.toString().split(' ')[0]}'),
                    leading: CircleAvatar(
                      backgroundColor: todo.color,
                    ),
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (bool? value) {
                        todoProvider.toggleTodoCompletion(todo);
                      },
                    ),

                    onTap: () async {
                      final updatedTodo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoEditScreen(todo: todo),
                        ),
                      );
                      if (updatedTodo != null) {
                        todoProvider.updateTodo(updatedTodo);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoCreateScreen(userId: widget.userId),
            ),
          );
        },
          child: Icon(Icons.add),
        ),
    );
  }
}