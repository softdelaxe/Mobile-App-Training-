import 'package:test/test.dart';

import 'package:testing/calculator.dart';

void main() {
  group('Calculator', () {
    Calculator calculator = Calculator();
    test('add', () {
      expect(calculator.add(2, 2), 4);
      expect(calculator.add(-1, 1), 0);
      expect(calculator.add(-1, -1), -2);
    });
    test('subtract', () {
      expect(calculator.subtract(2, 2), 0);
      expect(calculator.subtract(-1, 1), -2);
      expect(calculator.subtract(-1, -1), 0);
    });

    test('multiply', () {
      expect(calculator.multiply(2, 2), 4);
      expect(calculator.multiply(-1, 1), -1);
      expect(calculator.multiply(-1, -1), 1);
    });

    test('divide', () {
      expect(calculator.divide(2, 2), 1);
      expect(calculator.divide(-1, 1), -1);
      expect(calculator.divide(-1, -1), 1);
      expect(() => calculator.divide(2, 0), throwsException);
    });
  });
}
