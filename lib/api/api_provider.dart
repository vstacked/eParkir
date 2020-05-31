import 'dart:convert';

import 'package:eparkir/models/api_model.dart';
import 'package:eparkir/services/checkConnection.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  CheckConnection checkConnection = CheckConnection();
  Future<List<ApiModel>> getDataPostFromApiAsync() async {
    return checkConnection.checkConnection().then((_) async {
      if (checkConnection.hasConnection) {
        var response = await http.get('https://type.fit/api/quotes');

        if (response.statusCode != 404 && response.contentLength != 2) {
          final List rowData = jsonDecode(response.body);
          List<ApiModel> list =
              rowData.map((f) => ApiModel.fromJson(f)).toList();
          return list;
        } else {
          return null;
        }
      }
      return null;
    });
  }
}
