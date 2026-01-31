import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/presentation/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/core/routes/route_named.dart';
import 'package:jaku/core/utils/snackbar_widget.dart';
import 'package:jaku/presentation/widgets/note_widgets/note_global.dart';
import 'package:jaku/presentation/widgets/note_widgets/search_textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteDashboard extends StatefulWidget {
  const NoteDashboard({super.key});

  @override
  State<NoteDashboard> createState() => _NoteDashboardState();
}

class _NoteDashboardState extends State<NoteDashboard> {
  late NoteControllers noteC;

  @override
  void initState() {
    super.initState();
    noteC = Get.put(NoteControllers());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //make sure dispose everything before disposing notecontrollers
    Get.delete<NoteControllers>();
    print("dispose noteC");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    print(noteC.allNote);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        final notes = noteC.filteredNotes;

        try {
          if (noteC.isSortByCreatedDate.value && noteC.isAsce.value) {
            noteC.sortByCreatedAsc();
          } else if (noteC.isSortByCreatedDate.value && !noteC.isAsce.value) {
            noteC.sortByCreatedDesc();
          } else if (!noteC.isSortByCreatedDate.value && noteC.isAsce.value) {
            noteC.sortByEditedAsc();
          } else if (!noteC.isSortByCreatedDate.value && !noteC.isAsce.value) {
            noteC.sortByEditedDesc();
          }
        } catch (error) {
          showAppSnackbar(
            title: "Error!",
            message: "Gagal menambahkan note: $error",
            isSuccess: false,
          );
        }
        print("sort created: ${noteC.isSortByCreatedDate}");
        print("sort direction: ${noteC.isAsce}");

        for (var note in notes) {
          if (noteC.isSortByCreatedDate.value) {
            print(note.createdOn);
          } else {
            print(note.editedOn);
          }
        }

        final isLoading = noteC.isLoading.value;
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SearchTextfield(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: 12,
                      right: 12,
                      left: 12,
                      bottom: 60,
                    ),
                    child: notes.isNotEmpty
                        ? NoteGlobal(notes: notes)
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                  "Tidak ada note",
                                  style: theme.textTheme.bodyLarge,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.asset("images/malas.gif"),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        }
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNamed.addNote);
        },
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
