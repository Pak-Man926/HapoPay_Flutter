import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Spacing extends SizedBox {
  const Spacing.vertical(double height, {super.key}) : super(height: height);

  const Spacing.horizontal(double width, {super.key}) : super(width: width);
}

Future<PackageInfo> appVersionCheck() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  return packageInfo;
}
