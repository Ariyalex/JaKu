import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/widgets/note_widgets/sort_tile.dart';

class SortNoteModal extends StatelessWidget {
  const SortNoteModal({super.key});

  @override
  Widget build(BuildContext context) {
    final noteC = Get.find<NoteControllers>();

    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Sorting',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Divider(),
              Obx(() {
                final activeIndex = noteC.activeIndex;
                final isAsce = noteC.isAsce;
                final isSorting = noteC.isSorting;
                final isSortByCreated = noteC.isSortByCreatedDate;

                return Column(
                  children: [
                    SortTile(
                      isActive: activeIndex.value == 0,
                      title: 'None',
                      isSortable: false,
                      onTap: () {
                        activeIndex.value = 0;
                        isSorting.value = false;
                      },
                    ),
                    SortTile(
                      isActive: activeIndex.value == 1,
                      title: "Sort by Created Date",
                      onTap: () {
                        if (activeIndex.value != 1) {
                          isAsce.value = true;
                        } else {
                          isAsce.value = !isAsce.value;
                        }
                        activeIndex.value = 1;
                        isSorting.value = true;
                        isSortByCreated.value = true;
                      },
                      isAsce: isAsce.value,
                    ),
                    SortTile(
                      isActive: activeIndex.value == 2,
                      title: "Sort by Modified Date",
                      onTap: () {
                        if (activeIndex.value != 2) {
                          isAsce.value = true;
                        } else {
                          isAsce.value = !isAsce.value;
                        }
                        activeIndex.value = 2;
                        isSorting.value = true;
                        isSortByCreated.value = false;
                      },
                      isAsce: isAsce.value,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
