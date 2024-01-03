import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepat/src/core/constants/parameters.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';
import 'package:notepat/src/core/services/firebase_services.dart';
import 'package:notepat/src/ui/pages/add_note_page.dart';
import 'package:notepat/src/ui/pages/note_page.dart';
import 'package:notepat/src/ui/pages/search_notes_pages.dart';
import 'package:notepat/src/ui/pages/trash_page.dart';
import 'package:notepat/src/ui/widgets/cards/custom_cards.dart';
import 'package:notepat/src/ui/widgets/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:notepat/src/ui/widgets/custom_bottom_sheet/custom_bottom_sheet_controller.dart';
import 'package:notepat/src/ui/widgets/status_message/status_message.dart';

GlobalKey<ScaffoldState> homePageKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> homePageMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const HOME_PAGE_ROUTE = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late CustomBottomSheetController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CustomBottomSheetController(this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    final size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: homePageMessengerKey,
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primary(),
              onPressed: () =>
                  Navigator.pushNamed(context, AddNotePage.ADD_NOTE_PAGE_ROUTE),
              child: Icon(Icons.add, size: 25),
            ),
            backgroundColor: theme.background(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: fontColor(),
                  )),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(
                      context, SearchNotesPage.SEARCH_NOTES_PAGE_ROUTE),
                  icon: Icon(
                    CupertinoIcons.search,
                    color: fontColor(),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, TrashPage.TRASH_PAGE_ROUTE),
                  icon: Icon(
                    CupertinoIcons.delete_simple,
                    color: fontColor(),
                  ),
                ),
                /*IconButton(
                  onPressed: () {
                    _controller.open();
                  },
                  icon: Icon(
                    Icons.lock,
                    color: fontColor(),
                  ),
                )*/
              ],
            ),
            body: _Body(),
          ),
          Transform.translate(
            offset: Offset(
                0, size.height + 100 - (size.height * _controller.value)),
            child: CustomBottomSheet(
              close: () {
                _controller.close();
              },
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  FirebaseServices _services = FirebaseServices.instance;

  List<dynamic> notes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Notas",
            style: TextStyle(color: fontColor(), fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: FutureBuilder(
                future: _services.read("notes"),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return StatusMessage(() async {
                      await _services.read("notes");
                    }, StatusNetwork.Exception);
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    Map<String, dynamic> response = snapshot.data as  Map<String, dynamic>;
                    if (response["status"]==StatusNetwork.Connected) {
                      notes=response["data"];
                      return StaggeredGridView.countBuilder(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          Note nota;
                          if (notes[index].type == TypeNote.Text) {
                            nota = notes[index];
                            return SimpleCard(nota = notes[index], onTap: () {
                              print("Tipo de nota: ${nota.type}");

                              Navigator.pushNamed(
                                  context, NotePage.NOTE_PAGE_ROUTE,
                                  arguments: NotePageArguments(note: nota));
                            });
                          }
                          ;
                          if (notes[index].type == TypeNote.Image) {
                            nota = notes[index];
                            return ImageCard(nota = notes[index], onTap: () {
                              print("Tipo de nota: ${nota.type}");

                              Navigator.pushNamed(
                                  context, NotePage.NOTE_PAGE_ROUTE,
                                  arguments: NotePageArguments(note: nota));
                            });
                          }
                          if (notes[index].type == TypeNote.TextImage) {
                            nota = notes[index];
                            return TextImageCard(nota = notes[index],
                                onTap: () {
                              print("Tipo de nota: ${nota.type}");

                              Navigator.pushNamed(
                                  context, NotePage.NOTE_PAGE_ROUTE,
                                  arguments: NotePageArguments(note: nota));
                            });
                          }
                          return Container();
                        },
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(1, index.isEven ? 1 : 1.3),
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1.0,
                      );
                    }
                    else{
                      return StatusMessage(()async{

                      }, StatusNetwork.Exception);
                    }
                  }
                })),
      ],
    );
  }
}
