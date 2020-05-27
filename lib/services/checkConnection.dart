import 'dart:io';

class CheckConnection {
  bool hasConnection = false;
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return hasConnection = true;
      return hasConnection;
    } on SocketException catch (_) {
      return hasConnection = false;
    }
  }
}
