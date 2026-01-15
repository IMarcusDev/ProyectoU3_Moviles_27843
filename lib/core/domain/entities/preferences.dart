class Preferences {
  final double hotel;
  final double gastronomy;
  final double nature;
  final double culture;

  Preferences({
    required this.hotel,
    required this.gastronomy,
    required this.nature,
    required this.culture,
  });

  factory Preferences.empty() {
    return Preferences(
      hotel: 0,
      gastronomy: 0,
      nature: 0,
      culture: 0
    );
  }

  Preferences copyWith(
    double? hotel,
    double? gastronomy,
    double? nature,
    double? culture,
  ) {
    return Preferences(
      hotel: hotel ?? this.hotel,
      gastronomy: gastronomy ?? this.gastronomy,
      nature: nature ?? this.nature,
      culture: culture ?? this.culture,
    );
  }
}
