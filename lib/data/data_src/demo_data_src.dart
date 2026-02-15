import 'dart:convert';

import 'package:expense_tracker/data/data_src/data_source.dart';
import 'package:flutter/services.dart' show rootBundle;

class DemoDataSrc implements DataSource {
  int _lastId = 20;
  List<Map<String, dynamic>> _transaction = const [];
  List<String> _categories = const [];

  @override
  Future<Map<String, dynamic>> createTransaction(
    Map<String, dynamic> data,
  ) async {
    data['id'] = ++_lastId;
    _transaction.add(data);
    return data;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    _transaction.removeWhere((transaction) => transaction["id"] == "$id");
  }

  @override
  Future<List<Map<String, dynamic>>> getTransaction() async {
    if (_transaction.isNotEmpty) return _transaction;

    final String response = await rootBundle.loadString(
      'assets/transaction.json',
    );
    final List data = jsonDecode(response);
    _transaction = List.from(data);
    return _transaction;
  }

  @override
  Future<List<String>> getCategories() async {
    if (_categories.isNotEmpty) return _categories;

    final String response = await rootBundle.loadString('assets/category.json');
    final List data = jsonDecode(response);
    _categories = List.from(data);

    return _categories;
  }
}
