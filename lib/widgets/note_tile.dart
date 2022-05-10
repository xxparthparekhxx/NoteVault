import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/notesDescription.dart';
import 'package:notes/widgets/checkbox.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatefulWidget {
  const NoteTile(
      {Key? key,
      required this.N,
      required this.index,
      this.selected,
      this.select,
      this.inputsactive = true})
      : super(key: key);
  final bool inputsactive;
  final Function? select;
  final Note N;
  final int index;
  final Function? selected;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  var x;
  late List<Map<String, Object>> newx;
  @override
  void initState() {
    print("initing");
    if (widget.N.isChecked) {
      x = jsonDecode(widget.N.description);
      newx = <Map<String, Object>>[
        ...x.map((e) {
          return Map<String, Object>.from(
              {"title": e['title'] as String, "value": e['value'] as bool});
        })
      ];
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.N.isChecked) {
      x = jsonDecode(widget.N.description);
      newx = <Map<String, Object>>[
        ...x.map((e) {
          return Map<String, Object>.from(
              {"title": e['title'] as String, "value": e['value'] as bool});
        })
      ];
      setState(() {});
    }
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Material(
        color: widget.N.color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onLongPress: () async {
            await HapticFeedback.vibrate();
            if (widget.select != null) widget.select!(widget.N);
          },
          onTap: widget.selected != null
              ? () => widget.selected!()
              : () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => NotesDescription(
                                N: widget.N,
                                index: widget.index,
                              ))).then((value) {
                    setState(() {});
                  }),
          child: Container(
              width: 300,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.N.title,
                              maxLines: 1,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                      if (!widget.N.isChecked)
                        Text(
                          widget.N.description,
                          softWrap: true,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 14, overflow: TextOverflow.ellipsis),
                        ),
                      if (widget.N.isChecked)
                        Checkboxes(
                            activated: widget.inputsactive,
                            middle_padding: 10,
                            data: newx,
                            update:
                                (List<Map<String, Object>> e, int index) async {
                              await Provider.of<NP>(context, listen: false)
                                  .UpdateNotes(
                                      Note(
                                          title: widget.N.title,
                                          description: jsonEncode(e),
                                          time: widget.N.time,
                                          color: widget.N.color,
                                          isFav: widget.N.isFav,
                                          isChecked: true),
                                      widget.index);

                              setState(() {
                                newx = e;
                              });
                              Provider.of<NP>(context, listen: false).nt();
                            })
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(widget.N.time
                              .toString()
                              .split(".")[0]
                              .split(" ")[1]),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
