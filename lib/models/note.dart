import 'dart:convert';

import 'package:flutter/material.dart';

class Note {
  final String title;
  final String description;
  final DateTime time;
  final Color color;
  final bool isFav;
  final bool isChecked;

  Note(
      {required this.title,
      required this.description,
      required this.time,
      required this.color,
      required this.isFav,
      this.isChecked = false});

  String toJson() {
    return jsonEncode({
      "colors": [color.red, color.green, color.blue, color.opacity],
      "fav": isFav,
      "time": time.millisecondsSinceEpoch,
      "description": description,
      "title": title,
      "isChecked": isChecked
    });
  }

  @override
  String toString() {
    return {
      "colors": [color.red, color.green, color.blue, color.opacity],
      "fav": isFav,
      "time": time.millisecondsSinceEpoch,
      "description": description,
      "title": title,
      "isChecked": isChecked
    }.toString();
  }

  static Note fromJson(Map e) {
    List o = e['colors'] as List;

    return Note(
        color: Color.fromRGBO(o[0], o[1], o[2], o[3]),
        isFav: e['fav'],
        time: DateTime.fromMillisecondsSinceEpoch(e['time'] as int),
        description: e['description'],
        title: e["title"],
        isChecked: e['isChecked']);
  }
}
