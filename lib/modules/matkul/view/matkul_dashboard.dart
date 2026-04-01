import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/modules/matkul/bloc/matkul_bloc.dart';
import 'package:jaku/modules/matkul/bloc/matkul_event.dart';
import 'package:jaku/modules/matkul/bloc/matkul_state.dart';
import 'package:jaku/modules/matkul/widgets/matkul_dialogs.dart';
import 'package:jaku/modules/matkul/widgets/matkul_empty_widget.dart';
import 'package:jaku/modules/matkul/widgets/matkul_list_card_widget.dart';
import 'package:jaku/modules/matkul/widgets/matkul_semester_card_head.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MatkulDashboard extends HookWidget {
  const MatkulDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final matkulBloc = context.read<MatkulBloc>();
    final activeSemester = context.select(
      (MatkulBloc bloc) => bloc.state.activeSemester,
    );

    final isSelectionMode = useState<bool>(false);
    final selectedMatkul = useState<Set<String>>({});

    final editSemesterController = useTextEditingController();
    final editSemesterFormKey = GlobalKey<FormState>();

    void clearSelection() {
      isSelectionMode.value = false;
      selectedMatkul.value.clear();
    }

    bool isSemesterSelected(int semester) {
      return semester == activeSemester;
    }

    void toggleSemester(bool value, int semester) {
      if (value) {
        matkulBloc.add(SaveActiveSemester(semester));
      }
    }

    void toggleMatkul(String id) {
      final newSet = Set<String>.from(selectedMatkul.value);
      if (newSet.contains(id)) {
        newSet.remove(id);
      } else {
        newSet.add(id);
      }

      selectedMatkul.value = newSet;

      if (newSet.isEmpty) {
        isSelectionMode.value = false;
      }
    }

    void deleteMatkuls() {
      matkulBloc.add(DeleteMatkuls(selectedMatkul.value.toList()));
      clearSelection();
      context.pop();
    }

    void editSemesterMatkuls() {
      final selectedmatkuls = matkulBloc.state.matkuls
          .where((matkul) => selectedMatkul.value.contains(matkul.id))
          .toList();
      matkulBloc.add(
        UpdateListMatkulSemester(
          matkuls: selectedmatkuls,
          semester: int.parse(editSemesterController.text),
        ),
      );

      editSemesterController.text = "";
      clearSelection();
      context.pop();
    }

    return Scaffold(
      appBar: isSelectionMode.value
          ? AppBar(
              leading: IconButton(
                onPressed: clearSelection,
                icon: Icon(LucideIcons.x),
              ),
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
                    await MatkulDialogs.showDeleteMatkuls(
                      context,
                      deleteMatkuls,
                    );
                  },

                  icon: Icon(LucideIcons.trash2, color: Colors.red),
                ),
              ],
            )
          : AppBar(title: Text("Organisir Mata Kuliah")),
      body: SafeArea(
        child: BlocBuilder<MatkulBloc, MatkulState>(
          bloc: matkulBloc,
          builder: (context, state) {
            if (state.status == MatkulStatus.initial ||
                state.status == MatkulStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == MatkulStatus.success ||
                state.status == MatkulStatus.actionSuccess) {
              final Map<int, List<Matkul>> groupedMatkuls = groupBy(
                state.matkuls,
                (matkul) => matkul.semester,
              );

              final List<int> semesterKeys = groupedMatkuls.keys.toList()
                ..sort((a, b) => a.compareTo(b));

              if (semesterKeys.isEmpty) {
                return MatkulEmptyWidget();
              }

              return ListView.builder(
                itemCount: semesterKeys.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final int semester = semesterKeys[index];
                  final List<Matkul> listMatkulPerSemester =
                      groupedMatkuls[semester] ?? [];
                  return Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        MatkulSemesterCardHead(
                          title: semester >= 0
                              ? "Semester $semester"
                              : "Tidak Terkelompokkan",
                          isSelected: isSemesterSelected(semester),
                          onToggle: (value) => toggleSemester(value, semester),
                        ),
                        MatkulListCardWidget(
                          selectedMatkul: selectedMatkul.value,
                          isSelectionMode: isSelectionMode.value,
                          matkuls: listMatkulPerSemester,
                          setSelectionMode: (value) =>
                              isSelectionMode.value = value,
                          toggleMatkul: toggleMatkul,
                        ),
                      ],
                    ),
                  );
                },
                // Card(
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                //         alignment: Alignment.centerLeft,
                //         decoration: BoxDecoration(color: theme.colorScheme.secondary),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               "Semester 2",
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.bold,
                //                 color: theme.colorScheme.onPrimary,
                //               ),
                //             ),
                //             Switch(value: false, onChanged: (value) {}),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                //         child: MasonryGridView.builder(
                //           shrinkWrap: true,
                //           gridDelegate:
                //               const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 2,
                //               ),
                //           mainAxisSpacing: 8,
                //           crossAxisSpacing: 8,
                //           itemBuilder: (context, index) => Container(
                //             alignment: Alignment.center,
                //             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                //             decoration: BoxDecoration(
                //               color: theme.highlightColor,
                //               borderRadius: BorderRadius.circular(6),
                //             ),
                //             child: Text(
                //               "Basis Data",
                //               style: TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //           itemCount: 4,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Card(
                //   child: Column(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                //         alignment: Alignment.centerLeft,
                //         decoration: BoxDecoration(color: theme.colorScheme.secondary),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               "tidak tekelompokkan",
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.bold,
                //                 color: theme.colorScheme.onPrimary,
                //               ),
                //             ),
                //             Switch(value: false, onChanged: (value) {}),
                //           ],
                //         ),
                //       ),
                //       Container(
                //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                //         child: MasonryGridView.builder(
                //           shrinkWrap: true,
                //           gridDelegate:
                //               const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                //                 crossAxisCount: 2,
                //               ),
                //           mainAxisSpacing: 8,
                //           crossAxisSpacing: 8,
                //           itemBuilder: (context, index) => Container(
                //             alignment: Alignment.center,
                //             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                //             decoration: BoxDecoration(
                //               color: theme.highlightColor,
                //               borderRadius: BorderRadius.circular(6),
                //             ),
                //             child: Text(
                //               "Basis Data",
                //               style: TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //           itemCount: 4,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              );
            } else {
              return Center(child: Text("undifined state"));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => context.pushNamed(RouteNamed.addMatkul),
        shape: const CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
