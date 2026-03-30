import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/modules/matkul/widgets/edit_semester_dialog.dart';
import 'package:jaku/modules/matkul/widgets/matkul_list_card_widget.dart';
import 'package:jaku/modules/matkul/widgets/matkul_semester_card_head.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final dummyGroup = ["Semester 1", "Semester 2", "Tidak tekelompokkan"];

final dummyMatkul = ["Matkul 1", "Matkul 2", "Matkul 3", "Matkul 4"];

class MatkulDashboard extends HookWidget {
  const MatkulDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = useState<bool>(false);
    final selectedMatkul = useState<Set<int>>({});

    final editSemesterController = useTextEditingController();

    void toggleMatkul(int id) {
      final newSet = Set<int>.from(selectedMatkul.value);
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

    return Scaffold(
      appBar: isSelectionMode.value
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  isSelectionMode.value = false;
                  selectedMatkul.value.clear();
                },
                icon: Icon(LucideIcons.x),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await EditSemesterDialog.show(
                      context,
                      editSemesterController,
                    );
                  },
                  icon: Icon(LucideIcons.squarePen),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(LucideIcons.trash2, color: Colors.red),
                ),
              ],
            )
          : AppBar(title: Text("Matkul organizer")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyGroup.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) => Card(
            elevation: 0,
            child: Column(
              children: [
                MatkulSemesterCardHead(
                  title: dummyGroup[index],
                  isSelected: false,
                  onToggle: (value) {},
                ),
                MatkulListCardWidget(
                  selectedMatkul: selectedMatkul.value,
                  isSelectionMode: isSelectionMode.value,
                  dummyMatkul: dummyMatkul,
                  setSelectionMode: (value) => isSelectionMode.value = value,
                  toggleMatkul: toggleMatkul,
                ),
              ],
            ),
          ),
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
