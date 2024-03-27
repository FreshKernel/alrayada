import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    final settingsBloc = context.read<SettingsCubit>();
    if (settingsBloc.state.isAnimationsEnabled) {
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return;
    }
    _controller.jumpToPage(index);
  }

  List<Widget> get _pages => [
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.onlineShopping.path,
          title: context.loc.onlineShoppingMadeEasyFeature,
          subTitle: context.loc.onlineShoppingMadeEasyFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.cloudSecurity.path,
          title: context.loc.secureShoppingExperienceFeature,
          subTitle: context.loc.secureShoppingExperienceFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.wishlist.path,
          title: context.loc.favoritesWishlistFeature,
          subTitle: context.loc.favoritesWishlistFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.search.path,
          title: context.loc.easyFilteringAndSearchingFeature,
          subTitle: context.loc.easyFilteringAndSearchingFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.socialAuthentication.path,
          title: context.loc.socialAuthenticationFeature,
          subTitle: context.loc.socialAuthenticationFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.fastDelivery.path,
          title: context.loc.fastShippingFeature,
          subTitle: context.loc.fastShippingFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.support.path,
          title: context.loc.inAppSupportChatFeature,
          subTitle: context.loc.inAppSupportChatFeatureDesc,
        ),
        OnBoardingPage(
          imagePath: Assets.lottie.onboarding.programming.path,
          title: context.loc.underDevelopment,
          subTitle: context.loc.underDevelopmentFeatureDesc,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: _pages,
          ),
          Positioned(
            top: kToolbarHeight,
            right: 24,
            child: PlatformTextButton(
              onPressed: () => _navigateToPage(_pages.length - 1),
              child: Text(context.loc.skip),
            ),
          ),
          Positioned(
            left: 24,
            bottom: kBottomNavigationBarHeight + 25,
            child: SmoothPageIndicator(
              onDotClicked: (index) => _navigateToPage(index),
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotHeight: 15,
              ),
              controller: _controller,
              count: _pages.length,
            ),
          ),
          Positioned(
            right: 24,
            bottom: kBottomNavigationBarHeight,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  final newPageIndex = (_controller.page?.toInt() ?? 0) + 1;
                  if ((newPageIndex + 1) > _pages.length) {
                    // Reached last page
                    context.read<SettingsCubit>().dontShowOnBoardingScreen();
                    return;
                  }
                  _navigateToPage(
                    newPageIndex,
                  );
                },
                child: Icon(
                  isCupertino(context)
                      ? CupertinoIcons.arrow_right
                      : Icons.arrow_right,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    required this.imagePath,
    required this.title,
    required this.subTitle,
    super.key,
  });

  final String imagePath, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Lottie.asset(
            imagePath,
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.6,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
