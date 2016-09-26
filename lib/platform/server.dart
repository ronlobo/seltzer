import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:seltzer/src/context.dart';
import 'package:seltzer/src/interface.dart';

export 'package:seltzer/seltzer.dart';

/// Initializes `package:seltzer/seltzer.dart` to use [ServerSeltzerHttp].
///
/// This is appropriate for clients running in the VM on the command line.
void useSeltzerInTheServer() => setPlatform(const ServerSeltzerHttp());

/// An implementation of [SeltzerHttp] that works within the browser.
///
/// The "server" means in the Dart VM on the command line.
abstract class ServerSeltzerHttp implements SeltzerHttp {
  /// Use the default browser implementation of [SeltzerHttp].
  @literal
  const factory ServerSeltzerHttp() = _IOServerHttp;
}

class _IOServerHttp extends PlatformSeltzerHttp implements ServerSeltzerHttp {
  const _IOServerHttp();

  @override
  SeltzerHttpRequest request(String method, String url) {
    return new _IOSeltzerHttpRequest(method, url);
  }
}

class _IOSeltzerHttpRequest extends PlatformSeltzerHttpRequest {
  _IOSeltzerHttpRequest(String method, String url)
      : super(
          method: method,
          url: url,
        );

  @override
  Future<String> sendPlatform() async {
    var request = await new HttpClient().openUrl(method, Uri.parse(url));
    var response = await request.close();
    return UTF8.decodeStream(response);
  }
}