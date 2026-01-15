import 'package:turismo_app/core/domain/entities/preferences.dart';

class PreferencesModel {
  final double hotel;
  final double gastronomy;
  final double nature;
  final double culture;

  PreferencesModel({
    required this.hotel,
    required this.gastronomy,
    required this.nature,
    required this.culture,
  });

  factory PreferencesModel.empty() {
    return PreferencesModel(
      hotel: 0,
      gastronomy: 0,
      nature: 0,
      culture: 0
    );
  }

  PreferencesModel copyWith(
    double? hotel,
    double? gastronomy,
    double? nature,
    double? culture,
  ) {
    return PreferencesModel(
      hotel: hotel ?? this.hotel,
      gastronomy: gastronomy ?? this.gastronomy,
      nature: nature ?? this.nature,
      culture: culture ?? this.culture,
    );
  }

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      hotel: (json['hotel'] as num).toDouble(),
      gastronomy: (json['gastronomy'] as num).toDouble(),
      nature: (json['nature'] as num).toDouble(),
      culture: (json['culture'] as num).toDouble(),
    );
  }

  factory PreferencesModel.fromEntity(Preferences p) {
    return PreferencesModel(
      hotel: p.hotel,
      gastronomy: p.gastronomy,
      nature: p.nature,
      culture: p.culture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotel': hotel,
      'gastronomy': gastronomy,
      'nature': nature,
      'culture': culture,
    };
  }

  Preferences toEntity() {
    return Preferences(
      hotel: hotel,
      gastronomy: gastronomy,
      nature: nature,
      culture: culture,
    );
  }
}
