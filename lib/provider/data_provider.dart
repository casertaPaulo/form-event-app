import 'package:http/http.dart' as http;

class DataProvider {
  Future<http.Response> fetch(String document) async {
    return await http.get(Uri.parse(
        "https://api.cpfcnpj.com.br/5ae973d7a997af13f0aaf2bf60e65803/1/$document"));
  }
}
