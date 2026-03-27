import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

final dummyGroup = ["Semester 1", "Semester 2", "Tidak tekelompokkan"];

final dummyMatkul = ["Matkul 1", "Matkul 2", "Matkul 3", "Matkul 4"];

class MatkulDashboard extends HookWidget {
  const MatkulDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = useState<bool>(false);
    final selectedMatkul = useState<Set<int>>({});

    void toggleMatkul(int index) {
      final newSet = Set<int>.from(selectedMatkul.value);
      if (newSet.contains(index)) {
        newSet.remove(index);
      } else {
        newSet.add(index);
      }

      selectedMatkul.value = newSet;

      if (newSet.isEmpty) {
        isSelectionMode.value = false;
      }
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: isSelectionMode.value
          ? AppBar(
              leading: IconButton(
                onPressed: () {
                  isSelectionMode.value = false;
                  selectedMatkul.value.clear();
                },
                icon: Icon(Icons.close),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(LucideIcons.squarePen)),
              ],
            )
          : AppBar(title: Text("Matkul organizer")),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyGroup.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) => Card(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: theme.colorScheme.tertiary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dummyGroup[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      Switch(value: true, onChanged: (value) {}),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: MasonryGridView.builder(
                    shrinkWrap: true,
                    itemCount: dummyMatkul.length,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemBuilder: (context, index) {
                      final isSelected = selectedMatkul.value.contains(index);

                      return InkWell(
                        onLongPress: () {
                          if (!isSelectionMode.value) {
                            isSelectionMode.value = true;
                            toggleMatkul(index);
                          }
                        },

                        onTap: () {
                          if (isSelectionMode.value) {
                            toggleMatkul(index);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.cardTheme.color
                                : theme.highlightColor,
                            borderRadius: BorderRadius.circular(6),
                            border: BoxBorder.all(
                              width: 2,
                              color: isSelected
                                  ? theme.colorScheme.tertiary
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            dummyMatkul[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
    );
  }
}
