import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/theme.dart';

class ColorRow extends StatelessWidget {
  final int Selectedindex;
  final int indexColor;
  final bool foundtheme;
  final Function setindex;

  const ColorRow(
      {Key? key,
      required this.Selectedindex,
      required this.indexColor,
      required this.foundtheme,
      required this.setindex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < Col.length; i++)
            ColorTile(
              C: Col[i],
              isSelected: Selectedindex == i,
              setindex: setindex,
              myindex: i,
              Changecurrenttheme: !foundtheme && i == indexColor ? true : null,
            )
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
        try {
          if (Changecurrenttheme != null &&
              Theme.of(cont).scaffoldBackgroundColor != C) {
            Future.delayed(Duration.zero)
                .then((value) => setindex(myindex))
                .then((value) => ThemeSwitcher.of(cont).changeTheme(
                    theme: ThemeData(
                        primarySwatch: C,
                        backgroundColor: C,
                        scaffoldBackgroundColor: C)));
          }
        } catch (e) {}
        return GestureDetector(
          onTap: () {
            setindex(myindex);
            ThemeSwitcher.of(cont).changeTheme(
                theme: ThemeData(
                    primarySwatch: C,
                    backgroundColor: C,
                    scaffoldBackgroundColor: C));
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isSelected ? Colors.black : null),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: C,
            ),
          ),
        );
      },
    );
  }
}
