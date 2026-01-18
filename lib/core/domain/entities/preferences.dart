class Preferences {
  final String? id;
  final double hotel;
  final double gastronomy;
  final double nature;
  final double culture;

  Preferences({
    this.id,
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

  bool isValid() {
    return toList().reduce((a, b) => a + b) > 0;
  }

  List<double> toList() {
    return [hotel, gastronomy, nature, culture];
  }
}
