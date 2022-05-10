import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/input.dart';
import 'package:notes/theme.dart';
import 'package:notes/widgets/color_tiles.dart';
import 'package:notes/widgets/note_tile.dart';
import 'package:notes/widgets/popupmenu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

ThemeData savedtheme = ThemeData(
    primaryColor: Col[1],
    backgroundColor: Col[1],
    scaffoldBackgroundColor: Col[1]);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note>? selectednotes;

  Null Function()? selected(List<Note> Notes, int i) {
    return selectednotes != null
        ? () {
            if (selectednotes!.contains(Notes[i])) {
              selectednotes!
                  .removeWhere((Note element) => element.time == Notes[i].time);
            } else {
              selectednotes!.add(Notes[i]);
            }
            if (selectednotes!.isEmpty) {
              selectednotes = null;
            }
            setState(() {});
          }
        : null;
  }

  Contextualwidget({required bool Condition, child1, child2}) {
    return Condition ? child1 : child2;
  }

  Widget? floatingbutton() {
    return selectednotes == null
        ? FloatingActionButton(
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
                  CupertinoPageRoute(
                      builder: (c) => ThemeProvider(
                            initTheme: savedtheme,
                            duration: const Duration(milliseconds: 400),
                            builder: (context, mythemes) => MaterialApp(
                              theme: mythemes,
                              home: input(popper: () => Navigator.pop(c)),
                            ),
                          )),
                ))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<NP>(context);
    List<Note> Notes = Provider.of<NP>(context).SareNotes;
    var masonryGridView = MasonryGridView.count(
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: Notes.length,
      itemBuilder: (context, i) {
        Note n = Provider.of<NP>(context).SareNotes[i];
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: selectednotes != null
                  ? selectednotes!.contains(n)
                      ? Border.all(color: Colors.white, width: 2)
                      : Border.all(color: Colors.black, width: 2)
                  : Border.all(color: Colors.black, width: 2)),
          child: NoteTile(
            N: n,
            index: i,
            inputsactive: (selectednotes == null),
            selected: selected(Notes, i),
            select: (Note e) {
              setState(() {
                if (selectednotes == null) {
                  selectednotes = [e];
                } else if (!selectednotes!.contains(e)) {
                  selectednotes!.add(e);
                }
              });
            },
          ),
        );
      },
      crossAxisCount: 2,
    );

    var appBar2 = AppBar(
      title: Contextualwidget(
          Condition: Provider.of<NP>(context).currentSort == sort.color &&
              selectednotes == null,
          child1: const appbarcolortile(),
          child2: Contextualwidget(
              Condition: selectednotes != null,
              child1: Text(selectednotes?.length.toString() ?? ''),
              child2: const Text("Notes app"))),
      leading: Contextualwidget(
          Condition: selectednotes != null,
          child1: IconButton(
              onPressed: () => setState(() {
                    selectednotes = null;
                  }),
              icon: const Icon(Icons.arrow_back)),
          child2: null),
      actions: [
        Contextualwidget(
          Condition: selectednotes == null,
          child1: const popupmenu(),
          child2: IconButton(
              onPressed: () {
                Provider.of<NP>(context, listen: false)
                    .DeleteNote(notes: selectednotes!);
                selectednotes = null;
                setState(() {});
              },
              icon: const Icon(Icons.delete_forever)),
        )
      ],
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          backgroundColor: Colors.black12,
          appBar: appBar2,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Notes.isNotEmpty
                ? masonryGridView
                : const Center(
                    child: Text(
                    "Start by creating a note",
                    style: TextStyle(color: Colors.white),
                  )),
          ),
          floatingActionButton: floatingbutton()),
    );
  }
}

class appbarcolortile extends StatelessWidget {
  const appbarcolortile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorRow(
        Selectedindex: Col.indexOf((Provider.of<NP>(context).currentColor)),
        foundtheme: true,
        setindex: (int index) => {
              Provider.of<NP>(context, listen: false).currentColor = Col[index],
              Provider.of<NP>(context, listen: false).nt(),
              if (Provider.of<NP>(context, listen: false).currentSort !=
                  sort.color)
                {Provider.of<NP>(context, listen: false).resort = sort.color}
            });
  }
}
