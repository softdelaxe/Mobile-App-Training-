import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> getData() async {
    return await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
  }
}
