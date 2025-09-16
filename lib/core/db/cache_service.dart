import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class CacheService {
  static const String _cacheBoxName = 'cache_box';
  static const String _ttlPrefix = 'ttl_';
  static const String _dataPrefix = 'data_';

  late Box<String> _cacheBox;
  final Logger _logger = Logger();

  /// Initialize the cache service
  Future<void> initialize() async {
    try {
      _cacheBox = await Hive.openBox<String>(_cacheBoxName);
      _logger.i('Cache service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize cache service: $e');
      rethrow;
    }
  }

  /// Save data to cache with TTL (Time To Live) in minutes
  Future<void> save<T>(String key, T data, {int ttlMinutes = 30}) async {
    try {
      final now = DateTime.now();
      final expiryTime = now.add(Duration(minutes: ttlMinutes));

      final ttlKey = '$_ttlPrefix$key';
      final dataKey = '$_dataPrefix$key';

      // Store expiry time
      await _cacheBox.put(ttlKey, expiryTime.millisecondsSinceEpoch.toString());

      // Store data as JSON
      final jsonData = jsonEncode(data);
      await _cacheBox.put(dataKey, jsonData);

      _logger.d('Data cached with key: $key, TTL: ${ttlMinutes}minutes');
    } catch (e) {
      _logger.e('Failed to save data to cache: $e');
      rethrow;
    }
  }

  /// Retrieve data from cache if not expired
  Future<T?> get<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final ttlKey = '$_ttlPrefix$key';
      final dataKey = '$_dataPrefix$key';

      // Check if data exists
      if (!_cacheBox.containsKey(dataKey)) {
        _logger.d('Cache miss for key: $key');
        return null;
      }

      // Check TTL
      final ttlString = _cacheBox.get(ttlKey);
      if (ttlString == null) {
        _logger.d('No TTL found for key: $key, removing data');
        await _remove(key);
        return null;
      }

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(ttlString),
      );
      if (DateTime.now().isAfter(expiryTime)) {
        _logger.d('Data expired for key: $key, removing');
        await _remove(key);
        return null;
      }

      // Retrieve and parse data
      final jsonString = _cacheBox.get(dataKey);
      if (jsonString == null) {
        _logger.d('No data found for key: $key');
        return null;
      }

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final data = fromJson(jsonData);

      _logger.d('Cache hit for key: $key');
      return data;
    } catch (e) {
      _logger.e('Failed to get data from cache: $e');
      return null;
    }
  }

  /// Retrieve list data from cache if not expired
  Future<List<T>?> getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final ttlKey = '$_ttlPrefix$key';
      final dataKey = '$_dataPrefix$key';

      // Check if data exists
      if (!_cacheBox.containsKey(dataKey)) {
        _logger.d('Cache miss for list key: $key');
        return null;
      }

      // Check TTL
      final ttlString = _cacheBox.get(ttlKey);
      if (ttlString == null) {
        _logger.d('No TTL found for list key: $key, removing data');
        await _remove(key);
        return null;
      }

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(ttlString),
      );
      if (DateTime.now().isAfter(expiryTime)) {
        _logger.d('List data expired for key: $key, removing');
        await _remove(key);
        return null;
      }

      // Retrieve and parse data
      final jsonString = _cacheBox.get(dataKey);
      if (jsonString == null) {
        _logger.d('No list data found for key: $key');
        return null;
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final data = jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

      _logger.d('Cache hit for list key: $key');
      return data;
    } catch (e) {
      _logger.e('Failed to get list data from cache: $e');
      return null;
    }
  }

  /// Check if data exists and is not expired
  Future<bool> exists(String key) async {
    try {
      final ttlKey = '$_ttlPrefix$key';
      final dataKey = '$_dataPrefix$key';

      if (!_cacheBox.containsKey(dataKey)) {
        return false;
      }

      final ttlString = _cacheBox.get(ttlKey);
      if (ttlString == null) {
        await _remove(key);
        return false;
      }

      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(ttlString),
      );
      if (DateTime.now().isAfter(expiryTime)) {
        await _remove(key);
        return false;
      }

      return true;
    } catch (e) {
      _logger.e('Failed to check cache existence: $e');
      return false;
    }
  }

  /// Remove specific data from cache
  Future<void> _remove(String key) async {
    try {
      final ttlKey = '$_ttlPrefix$key';
      final dataKey = '$_dataPrefix$key';

      await _cacheBox.delete(ttlKey);
      await _cacheBox.delete(dataKey);

      _logger.d('Removed data from cache: $key');
    } catch (e) {
      _logger.e('Failed to remove data from cache: $e');
    }
  }

  /// Clear all cached data
  Future<void> clear() async {
    try {
      await _cacheBox.clear();
      _logger.i('Cache cleared successfully');
    } catch (e) {
      _logger.e('Failed to clear cache: $e');
      rethrow;
    }
  }

  /// Clear expired data
  Future<void> clearExpired() async {
    try {
      final now = DateTime.now();
      final keysToRemove = <String>[];

      for (final key in _cacheBox.keys) {
        if (key.toString().startsWith(_ttlPrefix)) {
          final ttlString = _cacheBox.get(key);
          if (ttlString != null) {
            final expiryTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(ttlString),
            );
            if (now.isAfter(expiryTime)) {
              final dataKey = key.toString().replaceFirst(
                _ttlPrefix,
                _dataPrefix,
              );
              keysToRemove.addAll([key.toString(), dataKey]);
            }
          }
        }
      }

      for (final key in keysToRemove) {
        await _cacheBox.delete(key);
      }

      _logger.i('Cleared ${keysToRemove.length ~/ 2} expired cache entries');
    } catch (e) {
      _logger.e('Failed to clear expired cache: $e');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      int totalEntries = 0;
      int expiredEntries = 0;
      final now = DateTime.now();

      for (final key in _cacheBox.keys) {
        if (key.toString().startsWith(_ttlPrefix)) {
          totalEntries++;
          final ttlString = _cacheBox.get(key);
          if (ttlString != null) {
            final expiryTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(ttlString),
            );
            if (now.isAfter(expiryTime)) {
              expiredEntries++;
            }
          }
        }
      }

      return {
        'totalEntries': totalEntries,
        'expiredEntries': expiredEntries,
        'validEntries': totalEntries - expiredEntries,
        'cacheSize': _cacheBox.length,
      };
    } catch (e) {
      _logger.e('Failed to get cache stats: $e');
      return {};
    }
  }

  /// Close the cache service
  Future<void> close() async {
    try {
      await _cacheBox.close();
      _logger.i('Cache service closed');
    } catch (e) {
      _logger.e('Failed to close cache service: $e');
    }
  }
}
