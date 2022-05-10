// ignore: file_names
import 'dart:convert';

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
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.N.color,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Provider.of<NP>(context).SareNotes[widget.index].isFav
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border_outlined),
            onPressed: () async {
              var n = Provider.of<NP>(context, listen: false)
                  .SareNotes[widget.index];
              await Provider.of<NP>(context, listen: false).UpdateNotes(
                  Note(
                      title: n.title,
                      description: n.description,
                      time: n.time,
                      color: n.color,
                      isFav: !n.isFav,
                      isChecked: n.isChecked),
                  widget.index);
            },
          )
        ],
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
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.N.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.N.time.toString().split(".")[0].split(" ")[1],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
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
                    middle_padding: 8,
                    data: newx,
                    update: (List<Map<String, Object>> e, int _) async {
                      await Provider.of<NP>(context, listen: false).UpdateNotes(
                          Note(
                              title: widget.N.title,
                              description: jsonEncode(e),
                              time: widget.N.time,
                              color: widget.N.color,
                              isFav: Provider.of<NP>(context, listen: false)
                                  .SareNotes[widget.index]
                                  .isFav,
                              isChecked: true),
                          widget.index);
                      if (mounted) {
                        setState(() {
                          newx = e;
                        });
                      }
                    })
            ],
          ),
        ),
      ),
    );
  }
}
