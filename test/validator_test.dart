import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_null_safety/app/sign_in/validators.dart';

void main() {
  test('non empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });

  test(' empty string', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });
}
