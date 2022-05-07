// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/services.dart';

class Minuscula extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue txtViejo, TextEditingValue txtNuevo) {
    return txtNuevo.copyWith(text: txtNuevo.text.toLowerCase());
  }
}

class Mayuscula extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue txtViejo, TextEditingValue txtNuevo) {
    return txtNuevo.copyWith(text: txtNuevo.text.toUpperCase());
  }
}
