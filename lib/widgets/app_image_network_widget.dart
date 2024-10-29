import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageNetworkWidget extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final FilterQuality? filterQuality;

  const AppImageNetworkWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.filterQuality,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      filterQuality: filterQuality ?? FilterQuality.low,
      errorWidget: (context, url, error) => buildPlaceHolder(context),
      progressIndicatorBuilder: (_, __, ___) => buildPlaceHolder(context),
    );
  }

  Widget buildPlaceHolder(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.image,
        size: 48,
      ),
    );
  }
}
