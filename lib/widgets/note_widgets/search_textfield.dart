import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({
    super.key,
  });

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Cari catatan',
        prefixIcon: Icon(Icons.search),
        suffixIcon: !_isFocused
            ? Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(LucideIcons.arrowDownUp),
                      onPressed: () {
                        // TODO: aksi filter
                      },
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.funnel),
                      onPressed: () {
                        // TODO: aksi filter
                      },
                    ),
                  ],
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        filled: true,
      ),
    );
  }
}
