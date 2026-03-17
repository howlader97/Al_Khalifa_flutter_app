import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/delivery_area_model.dart';

class DeliveryAreaProvider {
  static  String baseUrl = '$apiBaseUrl/delivery-areas/';

  Future<List<DeliveryAreaModel>> getDeliveryAreas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DeliveryAreaModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load delivery areas');
  }
}
