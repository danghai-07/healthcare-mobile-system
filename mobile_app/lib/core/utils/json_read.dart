/// Safe JSON field readers supporting camelCase and PascalCase API keys.
abstract final class JsonRead {
  static T? read<T>(Map<String, dynamic> json, String camelKey) {
    if (json.containsKey(camelKey)) {
      return json[camelKey] as T?;
    }
    final pascalKey = _toPascal(camelKey);
    if (json.containsKey(pascalKey)) {
      return json[pascalKey] as T?;
    }
    return null;
  }

  static String? string(Map<String, dynamic> json, String key) {
    final raw = read<dynamic>(json, key);
    return raw?.toString();
  }

  static int? intValue(Map<String, dynamic> json, String key) {
    final raw = read<dynamic>(json, key);
    if (raw is int) {
      return raw;
    }
    if (raw is num) {
      return raw.toInt();
    }
    return null;
  }

  static double? doubleValue(Map<String, dynamic> json, String key) {
    final raw = read<dynamic>(json, key);
    if (raw is double) {
      return raw;
    }
    if (raw is num) {
      return raw.toDouble();
    }
    return null;
  }

  static bool? boolValue(Map<String, dynamic> json, String key) {
    final raw = read<dynamic>(json, key);
    if (raw is bool) {
      return raw;
    }
    return null;
  }

  static DateTime? dateTime(Map<String, dynamic> json, String key) {
    final raw = string(json, key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }

  static List<Map<String, dynamic>> mapList(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static String _toPascal(String camel) {
    if (camel.isEmpty) {
      return camel;
    }
    return camel[0].toUpperCase() + camel.substring(1);
  }
}
