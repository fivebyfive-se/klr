import 'package:flutter/material.dart';
import 'package:klr/klr.dart';

class TogglableTextEditor extends StatefulWidget {
  TogglableTextEditor({
    this.initalText,
    this.onChanged,
    this.style,
    this.editorStyle,
    this.alignment,
  });

  final AlignmentGeometry alignment;
  final String initalText;
  final void Function(String) onChanged;
  final TextStyle style;
  final TextStyle editorStyle;

  @override
  _TogglableTextEditorState createState() => _TogglableTextEditorState();
}

class _TogglableTextEditorState extends State<TogglableTextEditor> {
  bool _editingText = false;
  TextEditingController _controller;
  FocusNode _focusNode;

  void _applyChange() {
    widget.onChanged?.call(_controller.text);
    setState(() => _editingText = false);
  }
  void _edit()
    => setState(() => _editingText = true);

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController.fromValue(
      TextEditingValue(text: widget.initalText)
    );
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _editingText) {
        _applyChange();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = KlrConfig.of(context).textTheme.bodyText1;
    
    return Container(
      alignment: widget.alignment ?? Alignment.centerLeft,
      child: _editingText 
      ? TextField(
          controller: _controller,
          focusNode: _focusNode,
          onEditingComplete: _applyChange,
          style: baseStyle.merge(widget.editorStyle),
        )
      : TextButton(
        child: Text(
          _controller.text,
          style: baseStyle.merge(widget.style)
        ),
        onPressed: _edit,
      )
    );
  }
}