part of 'app_text_field_widget.dart';

String? isString(String? string) {
  if (string == null || string.isEmpty) {
    return 'Field is required';
  }
  if (string.length < 3) {
    return 'Field must be at least 3 characters';
  }
  return null;
}