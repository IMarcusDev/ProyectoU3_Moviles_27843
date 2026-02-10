class Rating {
  final String? id;
  final String userId;
  final String userName;
  final String placeId;
  final int stars; // 1-5
  final String? comment;
  final DateTime createdAt;

  Rating({
    this.id,
    required this.userId,
    required this.userName,
    required this.placeId,
    required this.stars,
    this.comment,
    required this.createdAt,
  });

  Rating copyWith({
    String? id,
    String? userId,
    String? userName,
    String? placeId,
    int? stars,
    String? comment,
    DateTime? createdAt,
  }) {
    return Rating(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      placeId: placeId ?? this.placeId,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
