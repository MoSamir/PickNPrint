import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListViewAnimatorWidget extends StatelessWidget {


  final List<Widget> listChildrenWidgets ;
  final bool isScrollEnabled;
  final ScrollController scrollController;
  ListViewAnimatorWidget({this.listChildrenWidgets , this.scrollController , this.isScrollEnabled});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      key: GlobalKey(),
      child: ListView.builder(
        controller: scrollController,
        physics: isScrollEnabled ?? true ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        itemCount: listChildrenWidgets.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            delay:
            Duration(milliseconds: 250),
            position: index,
            duration: const Duration(
                milliseconds: 700),
            child: SlideAnimation(
              horizontalOffset: 200.0,
              child: FadeInAnimation(
                child: listChildrenWidgets[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
