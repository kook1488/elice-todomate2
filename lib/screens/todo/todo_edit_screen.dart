import 'package:flutter/material.dart';
import 'package:todomate/models/todo_model.dart';

class TodoEditScreen extends StatefulWidget {
  final Todo todo;

  const TodoEditScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoEditScreenState createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late DateTime _startDate;
  late DateTime _endDate;
  late Color _selectedColor;
  String? _selectedFriend;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _startDate = widget.todo.startDate;
    _endDate = widget.todo.endDate;
    _selectedColor = widget.todo.color;
    _selectedFriend = widget.todo.friendId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('투두리스트 수정'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildDateField('시작일', _startDate, (date) => setState(() => _startDate = date)),
            SizedBox(height: 16),
            _buildDateField('종료일', _endDate, (date) => setState(() => _endDate = date)),
            SizedBox(height: 16),
            Text('색상'),
            SizedBox(height: 8),
            _buildColorPicker(),
            SizedBox(height: 16),
            _buildFriendSelector(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTodo,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime initialDate, Function(DateTime) onChanged) {
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
    // TODO: Implement actual friend selection
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: '친구'),
      value: _selectedFriend,
      items: [
        DropdownMenuItem(child: Text('친구 1'), value: 'friend1'),
        DropdownMenuItem(child: Text('친구 2'), value: 'friend2'),
      ],
      onChanged: (value) => setState(() => _selectedFriend = value),
    );
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        userId: widget.todo.userId,
        title: _titleController.text,
        startDate: _startDate,
        endDate: _endDate,
        color: _selectedColor,
        isCompleted: widget.todo.isCompleted,
        sharedWithFriend: _selectedFriend != null,
        friendId: _selectedFriend,
      );
      Navigator.of(context).pop(updatedTodo);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}