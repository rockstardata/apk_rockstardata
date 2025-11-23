import 'package:email_validator/email_validator.dart';

/// Utilidades de validación
class Validators {
  /// Valida un email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es obligatorio';
    }
    if (!EmailValidator.validate(value)) {
      return 'Por favor, ingresa un email válido';
    }
    return null;
  }

  /// Valida un campo requerido
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  /// Valida un teléfono (formato básico)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }
    // Remover espacios y caracteres especiales
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.length < 9) {
      return 'El teléfono debe tener al menos 9 dígitos';
    }
    return null;
  }

  /// Valida un nombre
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  /// Valida un número positivo
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Debe ser un número válido';
    }
    if (number < 0) {
      return 'Debe ser un número positivo';
    }
    return null;
  }
}

