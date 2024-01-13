import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ColorRow extends StatelessWidget {
  final int Selectedindex;
  final bool foundtheme;
  final Function setindex;

  const ColorRow(
      {Key? key,
      required this.Selectedindex,
      required this.foundtheme,
      required this.setindex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < Col.length; i++)
            Expanded(
              child: ColorTile(
                C: Col[i],
                isSelected: Selectedindex == i,
                setindex: setindex,
                myindex: i,
              ),
            ),
        ],
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final MaterialColor C;
  final bool isSelected;
  final int myindex;
  final Function setindex;
  final bool? Changecurrenttheme;
  const ColorTile(
      {Key? key,
      required this.C,
      required this.isSelected,
      required this.myindex,
      required this.setindex,
      this.Changecurrenttheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (cont) {
        return GestureDetector(
          onTap: () {
            setindex(myindex);
            ThemeSwitcher.of(cont).changeTheme(
                isReversed: true,
                theme: ThemeData(
                    primarySwatch: C,
                    backgroundColor: C,
                    scaffoldBackgroundColor: C));
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : null),
            child: CircleAvatar(
              backgroundColor: C,
            ),
          ),
        );
      },
    );
  }
}
