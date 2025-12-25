import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nostrrdr/src/app/widgets/nr_bottom_fade.dart';
import 'package:nostrrdr/src/core/presentation/responsive_view.dart';
import 'package:nostrrdr/src/features/home/presentation/widgets/widgets.dart';

@RoutePage()
class HomeScreen extends ResponsiveView {
  const HomeScreen({super.key});

  @override
  Widget buildMobile(BuildContext context) {
    return HomeView(crossAxisCount: 2);
  }

  @override
  Widget buildDesktop(BuildContext context) {
    return HomeView(crossAxisCount: 4);
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.crossAxisCount});
  final int crossAxisCount;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<HomeFilterAndSearchState> _searchKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification) {
            _searchKey.currentState?.collapse();
          }
          return false;
        },
        child: Stack(
          children: [
            CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                const HomeAppBar(),
                HomeGrid(crossAxisCount: widget.crossAxisCount),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: HomeFilterAndSearch(
                key: _searchKey,
                isMobile: widget.crossAxisCount == 2,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: const NrBottomFade(),
            ),
          ],
        ),
      ),
    );
  }
}
