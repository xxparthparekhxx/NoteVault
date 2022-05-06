import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/np.dart';
import 'package:notes/screens/input.dart';
import 'package:notes/widgets/note_tile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<NP>(context);
    List<Note> Notes = p.SareNotes;
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Notes.isNotEmpty
            ? (GridView.builder(
                itemCount: Notes.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (c, index) => NoteTile(
                      N: Notes[index],
                      index: index,
                    )))
            : const Center(child: Text("Start by creating a note")),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.black),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => const input()))),
    );
  }
}
