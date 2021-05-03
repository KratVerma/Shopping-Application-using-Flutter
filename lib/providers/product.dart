import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  void _setFavValue(bool newValue) {
    isFav = newValue;
    notifyListeners();
  }

  Future<void> toggleFavStatus(String token, String usrId) async {
    final oldStatus = isFav;
    isFav = !isFav;
    notifyListeners();
    final url =
        'https://flutter-shop-77f46.firebaseio.com/userFavorites/$usrId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFav,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
