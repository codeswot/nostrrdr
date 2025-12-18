import 'package:flutter/widgets.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

extension NsecValidatorExtension on FormBuilderValidators {
  static FormFieldValidator<String> nsec({String? errorText}) {
    return (valueCandidate) {
      if (valueCandidate == null || valueCandidate.isEmpty) {
        return null; // Let required validator handle empty
      }

      if (!valueCandidate.startsWith('nsec')) {
        return errorText ?? 'Private key must start with "nsec"';
      }
      return null;
    };
  }
}
