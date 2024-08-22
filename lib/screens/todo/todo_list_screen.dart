import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/models/todo_model.dart';
import 'package:todomate/screens/account/loginscreen.dart';
import 'package:todomate/screens/todo/friend_search_screen.dart';
import 'package:todomate/screens/todo/todo_provider.dart';
import 'package:todomate/screens/todo/todo_create_screen.dart';
import 'package:todomate/screens/todo/todo_edit_screen.dart';
import 'package:intl/intl.dart';
import 'package:todomate/util/sharedpreference.dart';

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
      todoProvider = context.read<TodoProvider>();
      todoProvider.setCurrentUserId(widget.userId);
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

  void _loadTodos() async {
    try {
      await todoProvider.loadTodos(widget.userId);
      print('Todos loaded successfully. Count: ${todoProvider.todos.length}');
      for (var todo in todoProvider.todos) {
        print('Loaded todo: ${todo.title}, isCompleted: ${todo.isCompleted}, isFriendCompleted: ${todo.isFriendCompleted}');
      }
    } catch (e) {
      print('Error loading todos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('할 일 목록을 불러오는 데 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('투두리스트'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: _navigateToFriendSearch,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              TodoSharedPreference().setPreferenceWithKey('isAutoLogin', 'false');
            }
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = todoProvider.todos;
          print('Building TodoList. Number of todos: ${todos.length}');
          if (todos.isEmpty) {
            return Center(child: Text('투두리스트가 없습니다. 새로운 항목을 추가해보세요!'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => _buildTodoItem(todos[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTodo,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo) {
    print('Building todo item: ${todo.title}, isCompleted: ${todo.isCompleted}, isFriendCompleted: ${todo.isFriendCompleted}');
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteTodo(todo),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text('${DateFormat('yyyy-MM-dd').format(todo.startDate)} - ${DateFormat('yyyy-MM-dd').format(todo.endDate)}'),
        leading: CircleAvatar(
          backgroundColor: todo.color,
          child: todo.sharedWithFriend ? Icon(Icons.people, color: Colors.white, size: 20) : null,
        ),
        trailing: _buildTodoCheckboxes(todo),
        onTap: () => _navigateToEditTodo(todo),
      ),
    );
  }

  Widget _buildTodoCheckboxes(Todo todo) {
    return Container(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCheckbox('나', todo.isCompleted, (bool? value) {
            print('Toggling completion for todo: ${todo.id}, isCurrentUser: true');
            todoProvider.toggleTodoCompletion(todo.id, isCurrentUser: true);
          }),
          if (todo.sharedWithFriend) ...[
            SizedBox(width: 4),
            _buildCheckbox('친구', todo.isFriendCompleted, (bool? value) {
              print('Friend checkbox tapped for todo: ${todo.id}');
              _showFriendStatusChangeMessage();
            }),
          ],
        ],
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

  void _showFriendStatusChangeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('친구의 상태는 직접 변경할 수 없습니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteTodo(Todo todo) {
    todoProvider.deleteTodo(todo.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${todo.title} 삭제됨'),
        action: SnackBarAction(
          label: '삭제 취소',
          onPressed: () => todoProvider.addTodo(todo),
        ),
      ),
    );
  }

  void _navigateToFriendSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendSearchScreen(userId: widget.userId)),
    );
  }

  void _navigateToCreateTodo() async {
    final created = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoCreateScreen(userId: widget.userId),
      ),
    );
    if (created == true) {
      _loadTodos();
    }
  }

  void _navigateToEditTodo(Todo todo) async {
    final updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoEditScreen(todo: todo),
      ),
    );
    if (updatedTodo != null) {
      todoProvider.updateTodo(updatedTodo);
    }
  }
}