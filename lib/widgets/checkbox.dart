import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Checkboxes extends StatelessWidget {
  final List<Map<String, Object>> data;
  final Function update;
  const Checkboxes({Key? key, required this.data, required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < data.length; i++)
          CheckboxTile(
            obje: data[i],
            index: i,
            update: update,
            olddata: data,
          ),
        CreatenewccheckBox(
          update: update,
          olddata: data,
        )
      ],
    );
  }
}

class CreatenewccheckBox extends StatefulWidget {
  const CreatenewccheckBox(
      {Key? key, required this.update, required this.olddata})
      : super(key: key);
  final Function update;
  final List<Map<String, Object>> olddata;

  @override
  State<CreatenewccheckBox> createState() => _CreatenewccheckBoxState();
}

class _CreatenewccheckBoxState extends State<CreatenewccheckBox> {
  @override
  Widget build(BuildContext context) {
    //create

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        List<Map<String, Object>> newdata = widget.olddata;
        newdata.add({"value": false, "title": ''});
        widget.update(newdata);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.add_task),
          ),
          Text("add Create new"),
        ],
      ),
    );

    // editExisting;
  }
}

class CheckboxTile extends StatefulWidget {
  final Map<String, Object> obje;
  final Function update;
  final List<Map<String, Object>> olddata;
  final int? index;
  CheckboxTile(
      {Key? key,
      required this.obje,
      required this.update,
      required this.olddata,
      required this.index})
      : super(key: key);

  @override
  State<CheckboxTile> createState() => _CheckboxTileState();
}

class _CheckboxTileState extends State<CheckboxTile> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.obje['title'] as String;
    controller.addListener(() {
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (controller.text != widget.obje['title'] as String) {
      var newdata = widget.olddata;
      newdata[widget.index!]['title'] = controller.value.text;
      print(newdata);
      widget.update(newdata);
    }
    controller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Checkbox(
                value: widget.obje['value'] as bool,
                onChanged: (e) {
                  var newdata = widget.olddata;
                  newdata[widget.index!]['value'] = e as Object;
                  print(newdata);
                  widget.update(newdata);
                })),
        Expanded(
          child: Focus(
            onFocusChange: (value) {
              print(value);

              if (!value) {
                var newdata = widget.olddata;
                newdata[widget.index!]['title'] = controller.value.text;
                widget.update(newdata);
                print(newdata);
              }
            },
            child: TextField(
              controller: controller,
            ),
          ),
          flex: 9,
        )
      ],
    );
  }
}
