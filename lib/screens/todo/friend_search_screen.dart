import 'package:flutter/material.dart';
import 'package:todomate/models/signup_model.dart'; // 필요시 적절한 경로로 수정

class FriendSearchScreen extends StatefulWidget {
  final String userId;

  const FriendSearchScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _FriendSearchScreenState createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _friendRequests = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  Future<void> _loadFriendRequests() async {
    final requests = await _databaseHelper.getFriendRequests(widget.userId);
    setState(() {
      _friendRequests = requests;
    });
  }

  Future<void> _search() async {
    final results = await _databaseHelper.searchUsers(_searchController.text, widget.userId);
    setState(() {
      _searchResults = results;
    });
  }

  Future<void> _sendFriendRequest(String friendId) async {
    await _databaseHelper.sendFriendRequest(widget.userId, friendId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('친구 요청을 보냈습니다.')));
  }

  Future<void> _acceptFriendRequest(String senderId) async {
    await _databaseHelper.acceptFriendRequest(widget.userId, senderId);
    _loadFriendRequests();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('친구 요청을 수락했습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('친구 찾기')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '닉네임 검색',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return ListTile(
                        title: Text(user['nickname']),
                        trailing: IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: () => _sendFriendRequest(user['id'].toString()),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _friendRequests.length,
                    itemBuilder: (context, index) {
                      final request = _friendRequests[index];
                      return ListTile(
                        title: Text('친구 요청: ${request['sender_id']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () => _acceptFriendRequest(request['sender_id'].toString()),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
