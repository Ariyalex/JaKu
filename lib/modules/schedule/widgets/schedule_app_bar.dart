import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/schedule/bloc/schedule_bloc.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_selection_cubit.dart';
import 'package:jaku/modules/schedule/widgets/schedule_dialogs.dart';
import 'package:jaku/modules/setting/bloc/setting_bloc.dart';
import 'package:jaku/modules/setting/bloc/setting_event.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ScheduleAppBar extends HookWidget implements PreferredSizeWidget {
  const ScheduleAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = context.select(
      (ScheduleSelectionCubit cubit) => cubit.state.isSelectionMode,
    );

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    useEffect(() {
      if (isSelectionMode) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, [isSelectionMode]);

    final offsetAnimation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOutQuart),
        );

    return Stack(
      children: [
        _buildNormalAppBar(context),
        SlideTransition(
          position: offsetAnimation,
          child: _buildSelectionAppBar(context),
        ),
      ],
    );
  }

  Widget _buildNormalAppBar(BuildContext context) {
    final isCardView = context.select(
      (SettingBloc bloc) => bloc.state.setting.scheduleView,
    );
    final theme = Theme.of(context);
    return AppBar(
      key: const ValueKey("normal_app_bar"),
      title: const Text("Jaku"),
      actions: [
        TextButton.icon(
          onPressed: () =>
              context.read<SettingBloc>().add(ToggleScheduleView()),
          label: isCardView
              ? Text(
                  "Card view",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                )
              : Text(
                  "Table view",
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
          icon: isCardView
              ? const Icon(Icons.view_agenda_outlined)
              : const Icon(Icons.table_chart),
          style: ButtonStyle(
            backgroundColor: isCardView
                ? null
                : WidgetStatePropertyAll(theme.colorScheme.primary),
            iconColor: isCardView
                ? null
                : WidgetStatePropertyAll(theme.colorScheme.onPrimary),
            side: WidgetStatePropertyAll(
              BorderSide(width: 1, color: theme.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildSelectionAppBar(BuildContext context) {
    final selectionCubit = context.read<ScheduleSelectionCubit>();
    final selectedScheduleIds = context.select(
      (ScheduleSelectionCubit cubit) => cubit.state.selectedScheduleIds,
    );

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      key: const ValueKey("selection_app_bar"),
      leading: IconButton(
        onPressed: selectionCubit.clearSelection,
        icon: Icon(LucideIcons.x),
      ),
      title: Text("${selectedScheduleIds.length} terpilih"),
      actions: [
        IconButton(
          onPressed: () async {
            await ScheduleDialogs.showDeleteSchedules(context, () {
              context.read<ScheduleBloc>().add(
                DeleteSchedules(selectedScheduleIds.toList()),
              );
              selectionCubit.clearSelection();

              context.pop();
            });
          },

          icon: Icon(LucideIcons.trash2, color: Colors.red),
        ),
      ],
    );
  }
}
