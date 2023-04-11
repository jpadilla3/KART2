import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  const ShimmerLoader.rectangular({
    this.width = double.infinity,
    required this.height,
  });
  const ShimmerLoader.circular({
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.grey[300]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey,
      ));
}
