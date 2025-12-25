import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

class HomeGrid extends StatefulWidget {
  const HomeGrid({super.key, required this.crossAxisCount});
  final int crossAxisCount;

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  final List<String> bookCovers = [
    'https://images.pexels.com/photos/2954199/pexels-photo-2954199.jpeg',
    'https://images.pexels.com/photos/5530778/pexels-photo-5530778.jpeg',
    'https://images.pexels.com/photos/30390755/pexels-photo-30390755.jpeg',
    'https://images.pexels.com/photos/6353764/pexels-photo-6353764.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.crossAxisCount == 4 ? 16.w : 8.w,
        ),
        sliver: SliverGrid.builder(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: 8.w,
            crossAxisSpacing: 8.w,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: widget.crossAxisCount == 4
                ? const [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                  ]
                : const [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                  ],
          ),
          itemBuilder: (context, index) {
            return BookCover(title: 'Book $index', coverUrl: bookCovers[index]);
          },
          itemCount: bookCovers.length,
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.title, required this.coverUrl});
  final String title;
  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: NetworkImage(coverUrl),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.r),
            bottomRight: Radius.circular(8.r),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        padding: EdgeInsets.all(8.r),
        child: Text(
          title,
          style: context.textStyles.titleMedium.copyWith(
            color: context.colors.white,
          ),
        ),
      ),
    );
  }
}
