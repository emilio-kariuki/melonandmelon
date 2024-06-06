
import 'dart:convert';
import 'package:melonandmelon/utilities/packages.dart';

class LocalStorageManager {
    final SharedPreferences _sharedPreferences;
    const LocalStorageManager(this._sharedPreferences);

    Future<void> saveString(String key, String value) async {
        await _sharedPreferences.setString(key, value);
    }

    Future<String?> getString(String key) async {
        return _sharedPreferences.getString(key);
    }

    Future<void> saveBool(String key, bool value) async {
        await _sharedPreferences.setBool(key, value);
    }

    Future<bool?> getBool(String key) async {
        return _sharedPreferences.getBool(key);
    }

    Future<void> saveInt(String key, int value) async {
        await _sharedPreferences.setInt(key, value);
    }

    Future<int?> getInt(String key) async {
        return _sharedPreferences.getInt(key);
    }

    Future<void> saveDouble(String key, double value) async {
        await _sharedPreferences.setDouble(key, value);
    }

    Future<double?> getDouble(String key) async {
        return _sharedPreferences.getDouble(key);
    }

    Future<void> saveStringList(String key, List<String> value) async {
        await _sharedPreferences.setStringList(key, value);
    }

    Future<List<String>?> getStringList(String key) async {
        return _sharedPreferences.getStringList(key);
    }

    Future<void> remove(String key) async {
        await _sharedPreferences.remove(key);
    }

    Future<void> clear() async {
        await _sharedPreferences.clear();
    }

    Future<bool> containsKey(String key) async {
        return _sharedPreferences.containsKey(key);
    }

    Future<void> saveObject(String key, Object value) async {
        final String jsonString = jsonEncode(value);
        await _sharedPreferences.setString(key, jsonString);
    }

    Future<T?> getObject<T>(String key) async {
        final String? jsonString = _sharedPreferences.getString(key);
        if (jsonString == null) {
        return null;
        }
        return jsonDecode(jsonString) as T;
    }

    Future<void> saveObjectList(String key, List<Object> value) async {
        final List<String> jsonStringList =
            value.map((e) => jsonEncode(e)).toList();
        await _sharedPreferences.setStringList(key, jsonStringList);
    }

    Future<List<T>?> getObjectList<T>(String key) async {
        final List<String>? jsonStringList = _sharedPreferences.getStringList(key);
        if (jsonStringList == null) {
        return null;
        }
        return jsonStringList.map((e) => jsonDecode(e) as T).toList();
    }

    Future<void> saveObjectMap(String key, Map<String, Object> value) async {
        final Map<String, String> jsonStringMap =
            value.map((key, value) => MapEntry(key, jsonEncode(value)));
        await _sharedPreferences.setString(key, jsonEncode(jsonStringMap));
    }

    Future<Map<String, T>?> getObjectMap<T>(String key) async {
        final String? jsonString = _sharedPreferences.getString(key);
        if (jsonString == null) {
        return null;
        }
        final Map<String, String> jsonStringMap = jsonDecode(jsonString);
        return jsonStringMap
            .map((key, value) => MapEntry(key, jsonDecode(value) as T));
    }

    Future<void> saveObjectListMap(
        String key, List<Map<String, Object>> value) async {
        final List<String> jsonStringList =
            value.map((e) => jsonEncode(e)).toList();
        await _sharedPreferences.setStringList(key, jsonStringList);
    }

    Future<List<Map<String, T>>?> getObjectListMap<T>(String key) async {
        final List<String>? jsonStringList = _sharedPreferences.getStringList(key);
        if (jsonStringList == null) {
        return null;
        }
        return jsonStringList.map((e) => jsonDecode(e) as Map<String, T>).toList();
    }

    Future<void> saveObjectMapList(
        String key, Map<String, List<Object>> value) async {
        final Map<String, List<String>> jsonStringMap = value.map((key, value) =>
            MapEntry(key, value.map((e) => jsonEncode(e)).toList()));
        await _sharedPreferences.setString(key, jsonEncode(jsonStringMap));
    }

    Future<Map<String, List<T>>?> getObjectMapList<T>(String key) async {
        final String? jsonString = _sharedPreferences.getString(key);
        if (jsonString == null) {
        return null;
        }
        final Map<String, List<String>> jsonStringMap = jsonDecode(jsonString);
        return jsonStringMap.map((key, value) =>
            MapEntry(key, value.map((e) => jsonDecode(e) as T).toList()));
    }
}
