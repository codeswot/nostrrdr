import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

class HomeFilterAndSearch extends StatefulWidget {
  const HomeFilterAndSearch({super.key, required this.isMobile});
  final bool isMobile;

  @override
  State<HomeFilterAndSearch> createState() => HomeFilterAndSearchState();
}

class HomeFilterAndSearchState extends State<HomeFilterAndSearch> {
  bool _isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  void collapse() {
    if (_isExpanded) {
      if (mounted) {
        setState(() {
          _isExpanded = false;
        });
      }
      _focusNode.unfocus();
    }
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidePadding = widget.isMobile ? 16.w : 32.w;
    final availableWidth =
        MediaQuery.of(context).size.width - (sidePadding * 2);
    final targetWidth = _isExpanded ? availableWidth - 60.w : 50.w;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sidePadding,
      ).copyWith(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
          SizedBox(width: 8.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            width: targetWidth,
            height: 50.h,
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 400),
              reverse: !_isExpanded,
              transitionBuilder: (child, animation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  fillColor: Colors.transparent,
                  child: child,
                );
              },
              child: _isExpanded
                  ? _buildSearchBar(context)
                  : _buildSearchButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton.filledTonal(
      key: const ValueKey('closed'),
      onPressed: _toggle,
      icon: const Icon(Icons.search),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return ClipRRect(
      key: const ValueKey('open'),
      borderRadius: BorderRadius.circular(32.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.r, sigmaY: 8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.theme.appBarTheme.backgroundColor?.withValues(
              alpha: .8,
            ),
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: context.theme.appBarTheme.foregroundColor,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Search...',
                    isDense: true,
                    hintStyle: context.textStyles.bodyMedium.copyWith(
                      color: context.theme.appBarTheme.foregroundColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _toggle,
                child: Icon(
                  Icons.close,
                  color: context.theme.appBarTheme.foregroundColor,
                  size: 20.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
