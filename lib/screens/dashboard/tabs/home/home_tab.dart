import 'package:flutter/material.dart';

import '../../../../widgets/image_slider/image_slider_with_page_indicator.dart';
import '../../../../widgets/image_slider/simple_image_slider_tile.dart';
import 'chart_list.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  static const id = 'homeTab';

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> imageList = [
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageSliderWithPageIndicator.simple(
            items: imageList
                .map(
                  (e) => SimpleImageSliderItem(
                    title: 'No. ${imageList.indexOf(e)} Image',
                    imageUrl: e,
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 200, // Important
            child: ChartList(
              monthlyTotals: [
                MonthlyTotal(month: 1, amount: 500),
                MonthlyTotal(month: 8, amount: 200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
