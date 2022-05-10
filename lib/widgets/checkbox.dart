import 'package:flutter/material.dart';

class Checkboxes extends StatelessWidget {
  final List<Map<String, Object>> data;
  final Function update;
  final int? middle_padding;
  final int? selectedindex;
  final bool activated;
  const Checkboxes(
      {Key? key,
      required this.data,
      required this.update,
      this.middle_padding,
      this.selectedindex,
      this.activated = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < data.length; i++)
          CheckboxTile(
            obje: data[i],
            index: i,
            update: update,
            olddata: data,
            middle_padding: middle_padding,
            should_request_focus: selectedindex == i,
            activated: activated,
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
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          List<Map<String, Object>> newdata = widget.olddata;
          newdata.add({"value": false, "title": ''});
          widget.update(newdata, widget.olddata.length - 1);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              Expanded(
                child: Icon(Icons.add_task),
              ),
              Expanded(flex: 4, child: Text("add Create new")),
            ],
          ),
        ),
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
  final int? middle_padding;
  final bool? should_request_focus;
  final bool activated;
  const CheckboxTile(
      {Key? key,
      required this.obje,
      required this.update,
      required this.olddata,
      required this.index,
      this.middle_padding,
      this.should_request_focus = false,
      this.activated = true})
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

    super.initState();
  }

  @override
  void dispose() {
    if (controller.text != widget.obje['title'] as String) {
      var newdata = widget.olddata;
      newdata[widget.index!]['title'] = controller.value.text;
      if (mounted) () async => await widget.update(newdata, widget.index)();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.obje['title'] as String != controller.text) {
      controller.text = widget.obje['title'] as String;
    }

    return Row(
      children: [
        Expanded(
            flex: 8,
            child: Checkbox(
                value: widget.obje['value'] as bool,
                onChanged: widget.activated
                    ? (e) async {
                        var newdata = widget.olddata;
                        newdata[widget.index!]['value'] = e as Object;
                        await widget.update(newdata, widget.index!);
                      }
                    : null)),
        if (widget.middle_padding != null)
          Expanded(flex: widget.middle_padding!, child: const SizedBox()),
        Expanded(
          child: TextField(
            enabled: widget.activated,
            onChanged: (value) async {
              var newdata = widget.olddata;
              newdata[widget.index!]['title'] = controller.value.text;
              await widget.update(newdata, widget.index!);
            },
            autofocus: widget.should_request_focus!,
            controller: controller,
            style: widget.obje['value'] as bool
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          flex: 90,
        ),
        Expanded(
            flex: 25,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.activated
                  ? () async {
                      var newdata = widget.olddata;
                      newdata.removeAt(widget.index!);
                      await widget.update(newdata, widget.index);
                    }
                  : null,
            ))
      ],
    );
  }
}
