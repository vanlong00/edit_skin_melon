import 'package:flutter/material.dart';

class AppKeepAliveWidget extends StatefulWidget {
  const AppKeepAliveWidget({super.key, required this.child});

  final Widget child;

  @override
  State<AppKeepAliveWidget> createState() => _AppKeepAliveWidgetState();
}

class _AppKeepAliveWidgetState extends State<AppKeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
