class DeliveryAreaModel {
  final int id;
  final String city;
  final List<String> locations;

  DeliveryAreaModel({
    required this.id,
    required this.city,
    required this.locations,
  });

  factory DeliveryAreaModel.fromJson(Map<String, dynamic> json) => DeliveryAreaModel(
    id: json['id'],
    city: json['city'],
    locations: List<String>.from(json['locations']),
  );
}
