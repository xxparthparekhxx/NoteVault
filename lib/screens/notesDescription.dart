import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/widgets/checkbox.dart';
import 'package:provider/provider.dart';

class NotesDescription extends StatefulWidget {
  final Note N;
  final int index;
  const NotesDescription({Key? key, required this.N, required this.index})
      : super(key: key);

  @override
  State<NotesDescription> createState() => _NotesDescriptionState();
}

class _NotesDescriptionState extends State<NotesDescription> {
  var x;
  late List<Map<String, Object>> newx;
  @override
  void initState() {
    if (widget.N.isChecked) {
      x = jsonDecode(widget.N.description);
      newx = <Map<String, Object>>[
        ...x.map((e) {
          return Map<String, Object>.from(
              {"title": e['title'] as String, "value": e['value'] as bool});
        })
      ];
    }

    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// List<Map<String, Object>>

    return Scaffold(
      backgroundColor: widget.N.color,
      appBar: AppBar(
        backgroundColor: widget.N.color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.N.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.N.time.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (widget.N.isChecked == false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.N.description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              if (widget.N.isChecked)
                Checkboxes(
                    data: newx,
                    update: (List<Map<String, Object>> e) => {
                          Provider.of<NP>(context, listen: false).UpdateNotes(
                              Note(
                                  title: widget.N.title,
                                  description: jsonEncode(e),
                                  time: widget.N.time,
                                  color: widget.N.color,
                                  isFav: widget.N.isFav,
                                  isChecked: true),
                              widget.index),
                          setState(() {
                            newx = e;
                          })
                        })
            ],
          ),
        ),
      ),
    );
  }
}
