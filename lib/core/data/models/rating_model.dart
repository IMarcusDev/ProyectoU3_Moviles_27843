import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating.dart';

class RatingModel {
  final String? id;
  final String userId;
  final String userName;
  final String placeId;
  final int stars;
  final String? comment;
  final Timestamp createdAt;

  RatingModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.placeId,
    required this.stars,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Usuario',
      placeId: json['placeId'] ?? '',
      stars: json['stars'] ?? 0,
      comment: json['comment'],
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      'placeId': placeId,
      'stars': stars,
      if (comment != null && comment!.isNotEmpty) 'comment': comment,
      'createdAt': createdAt,
    };
  }

  Rating toEntity() {
    return Rating(
      id: id,
      userId: userId,
      userName: userName,
      placeId: placeId,
      stars: stars,
      comment: comment,
      createdAt: createdAt.toDate(),
    );
  }

  factory RatingModel.fromEntity(Rating rating) {
    return RatingModel(
      id: rating.id,
      userId: rating.userId,
      userName: rating.userName,
      placeId: rating.placeId,
      stars: rating.stars,
      comment: rating.comment,
      createdAt: Timestamp.fromDate(rating.createdAt),
    );
  }
}
