import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/notesDescription.dart';
import 'package:provider/provider.dart';

class NoteTile extends StatelessWidget {
  final int index;
  const NoteTile({
    Key? key,
    required this.N,
    required this.index,
  }) : super(key: key);

  final Note N;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Material(
        color: N.color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotesDescription(
                          N: N,
                          index: index,
                        )));
          },
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
                              N.title,
                              maxLines: 1,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                iconSize: 25,
                                onPressed: () {
                                  Provider.of<NP>(context, listen: false)
                                      .DeleteNote(index: index);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                      Text(
                        N.description,
                        softWrap: true,
                        maxLines: 4,
                        style: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(N.time.toString().split(".")[0].split(" ")[1]),
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
