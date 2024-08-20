import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todomate/screens/todo/todo_provider.dart';
import 'package:todomate/models/todo_model.dart';

class TodoCreateScreen extends StatefulWidget {
  final String userId;

  const TodoCreateScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TodoCreateScreenState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _startDate;
  late DateTime _endDate;
  Color _selectedColor = Colors.yellow;
  String? _selectedFriendId;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = _startDate.add(Duration(days: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadFriends(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create To-Do'),
        actions: [
          TextButton(
            child: Text('저장', style: TextStyle(color: Colors.black)),
            onPressed: _saveTodo,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '제목'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            SizedBox(height: 16),
            _buildDateField(
                '시작일', _startDate, (date) => setState(() => _startDate = date)),
            SizedBox(height: 16),
            _buildDateField(
                '종료일', _endDate, (date) => setState(() => _endDate = date)),
            SizedBox(height: 16),
            Text('색상'),
            SizedBox(height: 8),
            _buildColorPicker(),
            SizedBox(height: 16),
            _buildFriendSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      String label, DateTime initialDate, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(initialDate.toString().split(' ')[0]),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 8,
      children: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple
      ].map((color) => GestureDetector(
        onTap: () => setState(() => _selectedColor = color),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: _selectedColor == color ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildFriendSelector() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.friends.isEmpty) {
          return Text('추가된 친구가 없습니다.');
        }

        return DropdownButtonFormField<String?>(
          decoration: InputDecoration(labelText: '친구'),
          value: _selectedFriendId,
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text('친구 선택 안함'),
            ),
            ...todoProvider.friends.map((friend) {
              return DropdownMenuItem<String>(
                value: friend['id'].toString(),
                child: Text(friend['nickname'] ?? 'Unknown'),
              );
            }).toList(),
          ],
          onChanged: (value) => setState(() => _selectedFriendId = value),
        );
      },
    );
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTodo = Todo(
        id: DateTime.now().toString(),
        userId: widget.userId,
        title: _title,
        startDate: _startDate,
        endDate: _endDate,
        color: _selectedColor,
        isCompleted: false,
        sharedWithFriend: _selectedFriendId != null,
        friendId: _selectedFriendId,
      );

      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      todoProvider.addSharedTodo(newTodo);

      Navigator.of(context).pop(true);
    }
  }
}
