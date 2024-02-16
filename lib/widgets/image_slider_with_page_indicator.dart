import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@immutable
class ImageSliderItem {
  const ImageSliderItem({
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;
}

class ImageSliderWithPageIndicator extends StatefulWidget {
  const ImageSliderWithPageIndicator({
    required this.items,
    super.key,
  });

  final List<ImageSliderItem> items;

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
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) {
            final item = widget.items[index];
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Text(
                        item.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
          count: widget.items.length,
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
