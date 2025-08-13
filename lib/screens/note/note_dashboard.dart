import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaku/controllers/note_controllers/note_controllers.dart';
import 'package:jaku/routes/route_named.dart';
import 'package:jaku/widgets/note_widgets/note_global.dart';
import 'package:jaku/widgets/note_widgets/search_textfield.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteDashboard extends StatefulWidget {
  const NoteDashboard({super.key});

  @override
  State<NoteDashboard> createState() => _NoteDashboardState();
}

class _NoteDashboardState extends State<NoteDashboard> {
  late NoteControllers noteController;

  @override
  void initState() {
    super.initState();
    noteController = Get.put(NoteControllers());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<NoteControllers>();
    print("dispose noteC");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(noteController.allNote);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SearchTextfield(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 12,
                  right: 12,
                  left: 12,
                  bottom: 60,
                ),
                child: Obx(
                  () => noteController.allNote.isNotEmpty
                      ? NoteGlobal(notes: noteController.allNote)
                      : Center(
                          child: Column(
                            children: [
                              Text(
                                "Tidak ada note",
                                style: theme.textTheme.bodyLarge,
                              ),
                              Container(
                                margin: EdgeInsets.all(12),
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteNamed.addNote);
        },
        shape: const CircleBorder(),
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
