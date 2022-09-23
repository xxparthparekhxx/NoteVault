import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum sort {
  date,
  color,
  fav,
  all,
}

class NP with ChangeNotifier {
  SharedPreferences? prefs;
  sort currentSort = sort.all;
  List<Note> _SareNotes = [];
  MaterialColor currentColor = Col[1];

  List<Note> get SareNotes {
    List<Note> data = [];
    switch (currentSort) {
      case sort.date:
        data = sortedbydate;
        break;
      case sort.color:
        data = getByColor(currentColor);
        break;

      case sort.fav:
        data = favs;
        break;
      case sort.all:
        data = _SareNotes;
        break;
      default:
        break;
    }
    return data;
  }

  set resort(sort e) {
    currentSort = e;
    notifyListeners();
  }

  NP() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    String? Data = prefs!.getString("notes");
    if (Data == null) {
    } else {
      var usable = jsonDecode(Data);

      _SareNotes = (usable as List).map((e) {
        e = (jsonDecode(e) as Map);
        return Note.fromJson(e as Map);
      }).toList();

      notifyListeners();
    }
  }

  Future updateinprefs() async {
    String updatedNotes =
        jsonEncode(_SareNotes.map((e) => e.toJson()).toList());
    await prefs!.setString("notes", updatedNotes);
    _SareNotes =
        (jsonDecode(prefs!.getString("notes") as String) as List).map((e) {
      e = (jsonDecode(e) as Map);
      return Note.fromJson(e);
    }).toList();

    notifyListeners();
  }

  // CRUD Functions

  CreateNote({required Note N}) async {
    _SareNotes.add(N);
    notifyListeners();
    await updateinprefs();
  }

  DeleteNote({required List<Note> notes}) async {
    for (var ele in notes) {
      _SareNotes.removeWhere((element) => ele == element);
    }
    notifyListeners();
    await updateinprefs();
  }

  UpdateNotes(Note UpdatedNote, int index) async {
    _SareNotes[index] = UpdatedNote;
    await updateinprefs();
    notifyListeners();
  }

  nt() => notifyListeners();

  // Sorting functions

  List<Note> get sortedbydate {
    List<Note> ans = _SareNotes;
    ans.sort(
      (a, b) => a.time.millisecondsSinceEpoch
          .compareTo(b.time.millisecondsSinceEpoch),
    );
    return ans;
  }

  List<Note> getByColor(Color c) {
    List<Note> ans = [];
    for (var element in _SareNotes) {
      if (element.color.alpha == c.alpha &&
          element.color.blue == c.blue &&
          element.color.green == c.green) {
        ans.add(element);
      }
    }
    return ans;
  }

  List<Note> get favs {
    List<Note> ans = [];
    for (var element in _SareNotes) {
      if (element.isFav) {
        ans.add(element);
      }
    }
    return ans;
  }
}
