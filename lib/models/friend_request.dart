class FriendRequest {
  final int id;
  final int senderId;
  final int receiverId;
  final String status;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': status,
    };
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      status: map['status'],
    );
  }
}
