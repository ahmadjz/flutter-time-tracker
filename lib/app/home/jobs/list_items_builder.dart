import 'package:flutter/material.dart';
import 'package:time_tracker_null_safety/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {Key? key, required this.itemBuilder, required this.snapshot})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T>? items = snapshot.data;
      if (items!.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Somthing went wrong',
        message: 'can\'t load items right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

//this code doesn't add seprate line at the beginning and at the end
  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(
        context,
        items[index],
      ),
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
      ),
    );
  }
  // to add a sperate line at the beginning and at the end
  // Widget _buildList(List<T> items) {
  //   return ListView.separated(
  //     itemCount: items.length + 2,
  //     separatorBuilder: (context, index) => Divider(height: 0.5),
  //     itemBuilder: (context, index) {
  //       if (index == 0 || index == items.length + 1) {
  //         return Container();
  //       }
  //       return itemBuilder(context, items[index - 1]);
  //     },
  //   );
  // }

}
