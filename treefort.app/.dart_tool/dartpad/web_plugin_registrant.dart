// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:auth0_flutter/src/web.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  Auth0FlutterPlugin.registerWith(registrar);
  FluttertoastWebPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
