import 'package:flutter/foundation.dart';

class HistoryStore {
  HistoryStore._();

  static final HistoryStore instance = HistoryStore._();

  final ValueNotifier<List<Map<String, dynamic>>> items =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  void addScan(Map<String, dynamic> item) {
    final list = List<Map<String, dynamic>>.from(items.value);
    final id = item['id'];
    if (id != null && list.any((entry) => entry['id'] == id)) {
      return;
    }
    list.insert(0, item);
    items.value = list;
  }

  void clear() {
    items.value = [];
  }
}
