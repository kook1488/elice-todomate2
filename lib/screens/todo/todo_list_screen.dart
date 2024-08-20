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

class _TodoListScreenState extends State<TodoListScreen> with WidgetsBindingObserver {
  late TodoProvider todoProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todoProvider = Provider.of<TodoProvider>(context, listen: false);
      _loadTodos();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadTodos();
    }
  }

  void _loadTodos() {
    todoProvider.loadTodos(widget.userId);
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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTodos,
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
                    child: todo.sharedWithFriend ? Icon(Icons.people, color: Colors.white, size: 20) : null,
                  ),
                  trailing: todo.sharedWithFriend
                      ? Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildCheckbox('나', todo.isCompleted, (bool? value) {
                          todoProvider.toggleTodoCompletion(todo.id, isCurrentUser: true);
                        }),
                        SizedBox(width: 4),
                        _buildCheckbox('친구', todo.isFriendCompleted, null),
                      ],
                    ),
                  )
                      : Checkbox(
                    value: todo.isCompleted,
                    onChanged: (bool? value) {
                      todoProvider.toggleTodoCompletion(todo.id, isCurrentUser: true);
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
        onPressed: () async {
          final created = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodoCreateScreen(userId: widget.userId),
            ),
          );
          if (created == true) {
            _loadTodos();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?)? onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 10)),
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}