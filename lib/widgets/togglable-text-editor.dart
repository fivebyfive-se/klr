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
    final klr = KlrConfig.of(context);
    final baseStyle = klr.textTheme.bodyText1;
    final textFieldStyle = baseStyle.merge(widget.editorStyle);
    final buttonTextStyle = baseStyle.merge(widget.style).copyWith(
      decoration: TextDecoration.underline,
      color: klr.theme.secondaryAccent
    );
    
    return Container(
      alignment: widget.alignment ?? Alignment.centerLeft,
      padding: EdgeInsets.zero,
      height: baseStyle.fontSize * 1.5,
      child: _editingText 
      ? TextField(
          controller: _controller,
          focusNode: _focusNode,
          onEditingComplete: _applyChange,
          style: textFieldStyle,
        )
      : TextButton(
        child: Text(_controller.text),
        onPressed: _edit,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.zero
          ),
          fixedSize: MaterialStateProperty.all(
            Size.fromHeight(baseStyle.fontSize * 1.5)
          ),
          textStyle: MaterialStateProperty.all(buttonTextStyle),
          
          minimumSize: MaterialStateProperty.all(Size(0, 0))
        ),
      )
    );
  }
}