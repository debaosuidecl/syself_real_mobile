import 'dart:io';

import 'package:flutter/material.dart';

// import 'platform/'
class PlatformSpecific extends StatelessWidget {
  final Widget android;
  final Widget ios;

  PlatformSpecific({
    @required this.android,
    @required this.ios,
  });
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? ios : android;
  }
}
