import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReadMoreWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const ReadMoreWidget({super.key, required this.child, required this.scrollController});

  @override
  State<ReadMoreWidget> createState() => _ReadMoreWidgetState();
}

class _ReadMoreWidgetState extends State<ReadMoreWidget> {
  final _descriptionKey = GlobalKey();
  final double minHeightWidget = 192;

  bool _isExpanded = false;
  bool _isHideExpanded = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double widgetHeight = getHeightOfWidget();
      if (widgetHeight > 200) {
        setState(() {
          _isHideExpanded = false;
        });
      }
    });
  }

  double getHeightOfWidget() {
    final RenderBox renderBox = _descriptionKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  Future<void> _toggle() async {
    await widget.scrollController.animateTo(
      widget.scrollController.initialScrollOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: _isExpanded || _isHideExpanded ? null : minHeightWidget,
          child: Stack(
            children: [
              SingleChildScrollView(
                key: _descriptionKey,
                physics: const NeverScrollableScrollPhysics(),
                child: widget.child,
              ),
              if (!_isExpanded) _buildReadMore(),
            ],
          ),
        ),
        if (_isExpanded) _buildReadMore(),
      ],
    );
  }

  Widget _buildReadMore() {
    if (_isHideExpanded) {
      return const SizedBox();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black, Colors.black54, Colors.black12],
          ),
        ),
        child: GestureDetector(
          onTap: _toggle,
          child: Text(
            _isExpanded ? 'Read Less' : 'Read More',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}