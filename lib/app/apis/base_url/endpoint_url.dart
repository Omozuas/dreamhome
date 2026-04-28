// ignore: library_prefixes
import 'package:flutter/foundation.dart' as Foundation;

class Endpoints {
  //static const baseUrl = 'https://';
  //LiVE ENDPOINT
  static const baseUrl = Foundation.kDebugMode
      ? 'https://rurblist-backend.onrender.com/api/'
      : 'https://rurblist-backend.onrender.com/api/';
}
