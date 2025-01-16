import 'package:test/test.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

void main() {
  Api api = Api();
  group('Api', () {
    test('get data', () async {
      http.Response response = await api.getData();
      expect(response.statusCode, 200);
      expect(response.body, isNotNull);
    });
  });
}
