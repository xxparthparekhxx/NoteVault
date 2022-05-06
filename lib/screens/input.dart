import 'dart:convert';
import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/theme.dart';
import 'package:notes/widgets/checkbox.dart';
import 'package:notes/widgets/color_tiles.dart';
import 'package:notes/widgets/decoratedinput.dart';
import 'package:provider/provider.dart';

class input extends StatefulWidget {
  const input({Key? key}) : super(key: key);

  @override
  State<input> createState() => _inputState();
}

class _inputState extends State<input> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  setindex(int index) {
    setState(() {
      Selectedindex = index;
    });
  }

  updatecheckboxe(List<Map<String, Object>> e) {
    setState(() {
      Checkboxe = e;
    });
  }

  List<Map<String, Object>> Checkboxe = [];

  late int Selectedindex = 0;
  bool inited = false;
  bool foundtheme = false;
  bool containscheckbox = false;

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      for (int i = 0; i < Col.length; i++) {
        if (Theme.of(context).backgroundColor == Col[i]) {
          setindex(i);
          setState(() {
            foundtheme = true;
          });
          break;
        }
      }
      if (!foundtheme) {}
    }
    final int indexColor = Random().nextInt(Col.length - 1);
    return ThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            reverse: true,
            children: [
              Column(
                children: [
                  ColorRow(
                      Selectedindex: Selectedindex,
                      indexColor: indexColor,
                      foundtheme: foundtheme,
                      setindex: setindex),
                  Cinput(
                      controller: title, lable: "Enter a Title", maxlines: 1),
                  const SizedBox(
                    height: 20,
                  ),
                  containscheckbox
                      ? Checkboxes(data: Checkboxe, update: updatecheckboxe)
                      : Cinput(
                          controller: description,
                          lable: "Description",
                          minlines: 4,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              containscheckbox = !containscheckbox;
                            });
                          },
                          icon: containscheckbox
                              ? Icon(Icons.cancel)
                              : Icon(Icons.task_alt))
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ThemeSwitcher(
                builder: (context) => FloatingActionButton(
                    backgroundColor: Colors.black,
                    isExtended: true,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await Future.delayed(
                          Duration(microseconds: Checkboxe.length * 120));
                      late Note e;
                      if (containscheckbox) {
                        e = Note(
                            title: title.text,
                            description: jsonEncode(Checkboxe),
                            time: DateTime.now(),
                            color: Col[Selectedindex],
                            isFav: false,
                            isChecked: true);
                      } else {
                        e = Note(
                            title: title.text,
                            description: description.text,
                            time: DateTime.now(),
                            color: Col[Selectedindex],
                            isFav: false);
                      }
                      bool created = false;
                      int i = 1;
                      while (!created && i < 100) {
                        try {
                          await Provider.of<NP>(context, listen: false)
                              .CreateNote(N: e);
                          created = true;
                        } catch (e) {
                          i++;

                          created = false;
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
