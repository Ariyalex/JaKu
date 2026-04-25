import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/services/native_ringtone_service.dart';
import 'package:jaku/modules/setting/bloc/setting_bloc.dart';
import 'package:jaku/modules/setting/bloc/setting_event.dart';
import 'package:jaku/modules/setting/bloc/setting_state.dart';
import 'package:jaku/modules/setting/widgets/change_theme_dialog.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nativeRingtoneService = getIt<NativeRingtoneService>();
    final theme = Theme.of(context);
    final settingBloc = context.read<SettingBloc>();
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Tema Tampilan", style: theme.textTheme.headlineMedium),
          ),
          BlocSelector<SettingBloc, SettingState, String>(
            selector: (state) {
              return state.setting.themeMode;
            },
            builder: (context, value) {
              return InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => ChangeThemeDialog(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Tema"), Text(value)],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Alarm & Notifikasi",
              style: theme.textTheme.headlineMedium,
            ),
          ),
          BlocSelector<SettingBloc, SettingState, String?>(
            selector: (state) {
              return state.setting.ringtoneTitle;
            },
            builder: (context, value) {
              return InkWell(
                onTap: () async {
                  final selectedUri = await nativeRingtoneService
                      .openRingtonePicker();

                  if (selectedUri != null) {
                    final ringtoneTitle = await nativeRingtoneService
                        .getRingtoneTitle(selectedUri);

                    print("ringtone title: $ringtoneTitle");

                    settingBloc.add(UpdateRingtone(selectedUri, ringtoneTitle));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Ringtone"), Text(value ?? "default")],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
