import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/note/bloc/note_bloc.dart';
import 'package:jaku/modules/note/bloc/note_state.dart';
import 'package:jaku/modules/note/widgets/filter_note_modal.dart';
import 'package:jaku/modules/note/widgets/search_textfield.dart';
import 'package:jaku/modules/note/widgets/sort_note_modal.dart';
import 'package:jaku/modules/schedule/widgets/looping_undifined_semester.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NoteDashboardAppbar extends HookWidget implements PreferredSizeWidget {
  const NoteDashboardAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isSearching = useState<bool>(false);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final textController = useTextEditingController();
    final focusController = useFocusNode();
    useListenable(focusController);

    void setSearching() {
      isSearching.value = true;
      focusController.requestFocus();
    }

    useEffect(() {
      if (!focusController.hasFocus) {
        isSearching.value = false;
      }
      return null;
    }, [focusController.hasFocus]);

    useEffect(() {
      if (isSearching.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isSearching.value]);

    final offSetAnimation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeInOutQuart,
          ),
        );

    return Stack(
      children: [
        _buildNormalAppBar(context, setSearching, textController),
        SlideTransition(
          position: offSetAnimation,
          child: _buildSearchAppBar(context, textController, focusController),
        ),
      ],
    );
  }

  Widget _buildNormalAppBar(
    BuildContext context,
    VoidCallback setSearching,
    TextEditingController textController,
  ) {
    final semester = context.select(
      (MatkulBloc bloc) => bloc.state.activeSemester,
    );

    final theme = Theme.of(context);

    return AppBar(
      key: const ValueKey('normal_appbar'),
      title: InkWell(
        onTap: () => context.pushNamed(RouteNamed.matkulDashboard),
        child: semester < 1
            ? LoopingUndifinedSemester()
            : Text("Semester $semester"),
      ),
      actions: [
        BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            bool isAsce = state.isAsce;

            return IconButton(
              icon: Icon(isAsce ? LucideIcons.arrowUp : LucideIcons.arrowDown),

              onPressed: () {
                showBarModalBottomSheet<void>(
                  barrierColor: Colors.black.withValues(alpha: 0.4),
                  context: context,
                  useRootNavigator: true,
                  bounce: true,
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  builder: (context) => const SortNoteModal(),
                );
              },
            );
          },
        ),
        BlocBuilder<NoteBloc, NoteState>(
          builder: (context, state) {
            bool isFiltering = state.filterMatkulId != 'all';

            if (isFiltering) {
              return RawMaterialButton(
                onPressed: () {
                  showBarModalBottomSheet<void>(
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    context: context,
                    useRootNavigator: true,
                    bounce: true,
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    builder: (context) => const FilterNoteModal(),
                  );
                },
                fillColor: theme.colorScheme.tertiary,
                shape: const CircleBorder(),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                elevation: 0,
                child: Badge(
                  smallSize: 8,
                  alignment: Alignment.topRight,
                  child: Icon(
                    LucideIcons.funnel,
                    color: theme.colorScheme.onTertiary,
                  ),
                ),
              );
            }
            return IconButton(
              icon: const Icon(LucideIcons.funnel),
              onPressed: () {
                showBarModalBottomSheet<void>(
                  barrierColor: Colors.black.withValues(alpha: 0.4),
                  context: context,
                  useRootNavigator: true,
                  bounce: true,
                  backgroundColor: theme.colorScheme.surfaceContainer,
                  builder: (context) => const FilterNoteModal(),
                );
              },
            );
          },
        ),
        IconButton(
          onPressed: setSearching,
          icon: textController.text.isNotEmpty
              ? Badge(smallSize: 8, child: Icon(LucideIcons.search))
              : Icon(LucideIcons.search),
        ),
      ],
    );
  }

  Widget _buildSearchAppBar(
    BuildContext context,
    TextEditingController textController,
    FocusNode focusNode,
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: SearchTextfield(
        searchController: textController,
        focusNode: focusNode,
      ),
    );
  }
}
