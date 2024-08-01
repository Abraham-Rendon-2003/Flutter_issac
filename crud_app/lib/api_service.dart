import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item_model.dart';

class ApiService {
  final String baseUrl = "https://5zzx0m5c00.execute-api.us-east-1.amazonaws.com/dev";

  Future<List<Item>> getItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error fetching items: $e');
      throw Exception('Failed to load items');
    }
  }


  Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  Future<Item> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }

  Future<void> deleteItem(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/items?id=$id'),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete item');
    }
  }
}
