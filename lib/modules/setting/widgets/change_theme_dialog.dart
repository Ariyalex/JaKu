import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/utils/theme_mode_utils.dart';
import 'package:jaku/modules/setting/bloc/setting_bloc.dart';
import 'package:jaku/modules/setting/bloc/setting_event.dart';
import 'package:jaku/modules/setting/bloc/setting_state.dart';

class ChangeThemeDialog extends StatelessWidget {
  const ChangeThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();
    return AlertDialog(
      title: Text("Pilih tema"),
      content: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return RadioGroup<ThemeMode>(
            onChanged: (value) {
              // print("berjalan $value");
              settingBloc.add(
                UpdateThemeMode(
                  ThemeModeUtils.themeModeToString(value ?? ThemeMode.system),
                ),
              );

              context.pop();
            },
            groupValue: ThemeModeUtils.stringToThemeMode(
              state.setting.themeMode,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(value: ThemeMode.light, title: Text("Light")),
                RadioListTile(value: ThemeMode.dark, title: Text("Dark")),
                RadioListTile(
                  value: ThemeMode.system,
                  title: Text("System Theme"),
                ),
              ],
            ),
          );
        },
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      actions: [
        TextButton(onPressed: () => context.pop(), child: Text("Batal")),
      ],
    );
  }
}
