import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'Field ini']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? nim(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    final trimmed = value.trim();
    if (!RegExp(r'^\d{9,}$').hasMatch(trimmed)) {
      return AppStrings.validationNim;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.isEmpty) {
      return AppStrings.validationPrice;
    }
    final numValue = double.tryParse(cleaned);
    if (numValue == null || numValue <= 0) {
      return AppStrings.validationPrice;
    }
    return null;
  }

  static String? productName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama produk tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama produk minimal 3 karakter';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    if (value.trim().length < 10) {
      return 'Deskripsi minimal 10 karakter';
    }
    return null;
  }

  static String? githubUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL GitHub tidak boleh kosong';
    }
    final url = value.trim().toLowerCase();
    if (!url.startsWith('https://github.com/')) {
      return AppStrings.validationGithub;
    }
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.isAbsolute) {
      return 'Format URL tidak valid';
    }
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length < 2) {
      return 'URL harus dalam format: https://github.com/username/repo';
    }
    return null;
  }

  static String? sensitiveContent(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final lowerValue = value.toLowerCase();
    for (final keyword in AppStrings.sensitiveKeywords) {
      if (lowerValue.contains(keyword.toLowerCase())) {
        return AppStrings.validationSensitive;
      }
    }
    return null;
  }

  static String? requiredAndSafe(
    String? value, [
    String fieldName = 'Field ini',
  ]) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    return sensitiveContent(value);
  }

  static String? productNameSafe(String? value) {
    final nameError = productName(value);
    if (nameError != null) return nameError;
    return sensitiveContent(value);
  }

  static String? descriptionSafe(String? value) {
    final descError = description(value);
    if (descError != null) return descError;
    return sensitiveContent(value);
  }
}
