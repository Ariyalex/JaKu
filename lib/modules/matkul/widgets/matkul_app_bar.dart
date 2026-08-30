import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_selection_cubit.dart';
import 'package:jaku/modules/matkul/widgets/matkul_dialogs.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MatkulAppBar extends HookWidget implements PreferredSizeWidget {
  const MatkulAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = context.select(
      (MatkulSelectionCubit cubit) => cubit.state.isSelectionMode,
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
    return AppBar(
      key: const ValueKey("normal_app_bar"),
      title: Text("Organisir Mata Kuliah"),
    );
  }

  Widget _buildSelectionAppBar(BuildContext context) {
    final editSemesterController = useTextEditingController();
    final editSemesterFormKey = useMemoized(() => GlobalKey<FormState>());

    final matkulSelectionCubit = context.read<MatkulSelectionCubit>();
    final selectedMatkulIds = context.select(
      (MatkulSelectionCubit cubit) => cubit.state.selectedMatkulIds,
    );

    final matkulBloc = context.read<MatkulBloc>();

    void deleteMatkuls() {
      matkulBloc.add(DeleteMatkuls(selectedMatkulIds.toList()));
      matkulSelectionCubit.clearSelection();
      context.pop();
    }

    void editSemesterMatkuls() {
      final selectedmatkuls = matkulBloc.state.matkuls
          .where((matkul) => selectedMatkulIds.contains(matkul.id))
          .toList();
      matkulBloc.add(
        UpdateListMatkulSemester(
          matkuls: selectedmatkuls,
          semester: int.parse(editSemesterController.text),
        ),
      );

      editSemesterController.text = "";
      matkulSelectionCubit.clearSelection();
      context.pop();
    }

    return AppBar(
      key: const ValueKey("selection_app_bar"),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      leading: IconButton(
        onPressed: matkulSelectionCubit.clearSelection,
        icon: Icon(LucideIcons.x),
      ),
      title: Text("${selectedMatkulIds.length} terpilih"),
      actions: [
        IconButton(
          onPressed: () async {
            await MatkulDialogs.showEditSemesterDialog(
              context,
              editSemesterController,
              editSemesterMatkuls,
              editSemesterFormKey,
            );
          },
          icon: Icon(LucideIcons.squarePen),
        ),
        IconButton(
          onPressed: () async {
            await MatkulDialogs.showDeleteMatkuls(context, deleteMatkuls);
          },

          icon: Icon(LucideIcons.trash2, color: Colors.red),
        ),
      ],
    );
  }
}
