import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryStore {
  static final HistoryStore instance = HistoryStore._();
  static const _historyKey = 'scan_history';

  final ValueNotifier<List<Map<String, dynamic>>> items =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  bool _isLoaded = false;
  bool _pendingClear = false;
  final List<Map<String, dynamic>> _pendingAdds = [];

  HistoryStore._() {
    _load();
  }

  void addScan(Map<String, dynamic> item) {
    final list = List<Map<String, dynamic>>.from(items.value);
    final id = item['id'];
    if (id != null && list.any((entry) => entry['id'] == id)) {
      return;
    }
    list.insert(0, item);
    items.value = list;
    if (!_isLoaded) {
      _pendingAdds.add(item);
    }
    _persist();
  }

  void clear() {
    items.value = [];
    if (!_isLoaded) {
      _pendingClear = true;
      _pendingAdds.clear();
    }
    _persist();
  }

  Future<void> _load() async {
    List<Map<String, dynamic>> saved = [];
    try {
      final preferences = await SharedPreferences.getInstance();
      final encoded = preferences.getString(_historyKey);
      if (encoded != null) {
        saved = _decodeEntries(encoded);
      }
    } catch (_) {
      saved = [];
    }

    if (!_pendingClear) {
      for (final item in _pendingAdds) {
        final id = item['id'];
        if (id == null || !saved.any((entry) => entry['id'] == id)) {
          saved.insert(0, item);
        }
      }
    } else {
      saved = List<Map<String, dynamic>>.from(_pendingAdds);
      saved = saved.reversed.toList();
    }

    items.value = saved;
    _isLoaded = true;
    _pendingAdds.clear();
    _pendingClear = false;
    await _persist();
  }

  List<Map<String, dynamic>> _decodeEntries(String encoded) {
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .where(_isValidEntry)
          .toList();
    } catch (_) {
      return [];
    }
  }

  bool _isValidEntry(Map<String, dynamic> entry) {
    return entry['id'] is int &&
        entry['disease'] is String &&
        entry['confidence'] is String &&
        entry['date'] is String &&
        entry['imagePath'] is String &&
        entry['status'] is String;
  }

  Future<void> _persist() async {
    if (!_isLoaded) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_historyKey, jsonEncode(items.value));
    } catch (_) {
      // Keep the in-memory history available when local persistence fails.
    }
  }
}
