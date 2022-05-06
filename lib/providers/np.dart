import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notes/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NP with ChangeNotifier {
  SharedPreferences? _prefs;
  List<Note> SareNotes = [];
  NP() {
    init();
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
    String? Data = _prefs!.getString("notes");
    if (Data == null) {
    } else {
      var usable = jsonDecode(Data);

      SareNotes = (usable as List).map((e) {
        e = (jsonDecode(e) as Map);
        return Note.fromJson(e as Map);
      }).toList();

      notifyListeners();
    }
  }

  updateinprefs() async {
    String updatedNotes = jsonEncode(SareNotes.map((e) => e.toJson()).toList());
    _prefs!.setString("notes", updatedNotes);
    SareNotes =
        (jsonDecode(_prefs!.getString("notes") as String) as List).map((e) {
      e = (jsonDecode(e) as Map);
      return Note.fromJson(e);
    }).toList();

    notifyListeners();
  }

  // CRUD Functions

  CreateNote({required Note N}) async {
    SareNotes.add(N);
    notifyListeners();
    await updateinprefs();
  }

  DeleteNote({required int index}) async {
    SareNotes.removeAt(index);
    notifyListeners();
    await updateinprefs();
  }

  UpdateNotes(Note UpdatedNote, int index) async {
    SareNotes[index] = UpdatedNote;
    notifyListeners();
    await updateinprefs();
  }

  // Sorting functions

  List<Note> get sortedbydate {
    List<Note> ans = SareNotes;
    ans.sort(
      (a, b) => a.time.millisecondsSinceEpoch
          .compareTo(b.time.millisecondsSinceEpoch),
    );
    return ans;
  }

  List<Note> GetByColor(Color c) {
    List<Note> ans = [];
    SareNotes.forEach((element) {
      if (element.color == c) {
        ans.add(element);
      }
    });
    return ans;
  }

  List<Note> get favs {
    List<Note> ans = [];
    SareNotes.forEach((element) {
      if (element.isFav) {
        ans.add(element);
      }
    });
    return ans;
  }
}
