import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'simple_image_slider_tile.dart';

class ImageSliderWithPageIndicator extends StatefulWidget {
  const ImageSliderWithPageIndicator({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  factory ImageSliderWithPageIndicator.simple({
    required List<SimpleImageSliderItem> items,
  }) {
    return ImageSliderWithPageIndicator(
      itemCount: items.length,
      itemBuilder: (context, index, realIndex) {
        final item = items[index];
        return SimpleImageSliderTile(
          item: item,
        );
      },
    );
  }

  final int itemCount;
  final ExtendedIndexedWidgetBuilder itemBuilder;

  @override
  State<ImageSliderWithPageIndicator> createState() =>
      _ImageSliderWithPageIndicatorState();
}

class _ImageSliderWithPageIndicatorState
    extends State<ImageSliderWithPageIndicator> {
  var _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) =>
                setState(() => _activeIndex = index),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _activeIndex,
          count: widget.itemCount,
          onDotClicked: (newIndex) => setState(() => _activeIndex = newIndex),
          effect: ExpandingDotsEffect(
            activeDotColor:
                isCupertino(context) ? CupertinoColors.systemBlue : Colors.blue,
          ),
        )
      ],
    );
  }
}
