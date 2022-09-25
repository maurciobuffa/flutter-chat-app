import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://10.0.0.2:3000/api'
      : 'http://localhost:3000/api';
  static String sockedURL = Platform.isAndroid
      ? 'http://10.0.0.2:3000/api'
      : 'http://localhost:3000/api';
}
