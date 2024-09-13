export './qrscan/default.dart' // Stub implementation
    if (dart.library.io) './qrscan/native.dart' // dart:io implementation
    if (dart.library.js_interop) './qrscan/web.dart'; // package:web implementation