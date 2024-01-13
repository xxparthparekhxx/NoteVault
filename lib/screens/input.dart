import 'dart:convert';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/np.dart';
import '../theme.dart';
import '../widgets/checkbox.dart';
import '../widgets/color_tiles.dart';
import '../widgets/decoratedinput.dart';
import 'package:provider/provider.dart';

class input extends StatefulWidget {
  final Function popper;
  const input({Key? key, required this.popper}) : super(key: key);

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

  updatecheckboxe(List<Map<String, Object>> e, int selectedfield) {
    if (mounted) {
      setState(() {
        Checkboxe = e;
        selecedField = selectedfield;
      });
    }
  }

  int selecedField = 0;

  List<Map<String, Object>> Checkboxe = [];

  int Selectedindex = 0;
  bool inited = false;
  bool foundtheme = false;
  bool containscheckbox = false;
  createnoteAndUpdateInDb() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(microseconds: Checkboxe.length * 120));
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
    await Provider.of<NP>(context, listen: false).CreateNote(N: e);
    widget.popper();
  }

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
    return ThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            reverse: true,
            children: [
              AnimatedContainer(
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 100),
                  child: actualInput()),
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
                    onPressed: createnoteAndUpdateInDb,
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

  Column actualInput() {
    return Column(
      children: [
        ColorRow(
            Selectedindex: Selectedindex,
            foundtheme: foundtheme,
            setindex: setindex),
        Cinput(controller: title, lable: "Enter a Title", maxlines: 1),
        const SizedBox(
          height: 20,
        ),
        containscheckbox
            ? Checkboxes(
                data: Checkboxe,
                update: updatecheckboxe,
                selectedindex: selecedField,
              )
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
                    ? const Icon(Icons.cancel)
                    : const Icon(Icons.task_alt))
          ],
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
