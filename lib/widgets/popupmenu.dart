import 'package:flutter/material.dart';
import '../providers/np.dart';
import 'package:provider/provider.dart';

class popupmenu extends StatelessWidget {
  const popupmenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: Icon(Icons.sort),
      onSelected: (sort value) =>
          Provider.of<NP>(context, listen: false).resort = value,
      itemBuilder: (context) => const [
        PopupMenuItem(
            value: sort.date,
            child: ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Sort By Date"),
            )),
        PopupMenuItem(
            value: sort.color,
            child: ListTile(
              leading: Icon(Icons.format_paint),
              title: Text("Sort by Color"),
            )),
        PopupMenuItem(
            value: sort.fav,
            child: ListTile(
              leading: Icon(Icons.star),
              title: Text("Favorites only"),
            )),
        PopupMenuItem(
            value: sort.all,
            child: ListTile(
              leading: Icon(Icons.all_inbox_sharp),
              title: Text("All Notes"),
            )),
      ],
    );
  }
}
