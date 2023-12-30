import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepat/src/core/constants/parameters.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';
import 'package:notepat/src/ui/configure.dart';
import 'package:notepat/src/ui/pages/add_note_page.dart';
import 'package:notepat/src/ui/pages/note_page.dart';
import 'package:notepat/src/ui/widgets/cards/custom_cards.dart';

GlobalKey<ScaffoldState> notePrivatePageKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> NotePrivatePageMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Color fontColor() {
  return !ThemeController.instance.brightnessValue
      ? Colors.black
      : Colors.white;
}

class NotePrivatePage extends StatelessWidget {
  const NotePrivatePage({super.key});
  static const NOTE_PRIVATE_PAGE_ROUTE = "note_private_page";
  Color background() {
    return ThemeController.instance.brightnessValue
        ? Configure.BACKGROUND_DARK
        : Configure.BACKGROUND_LIGHT;
  }

  @override
  Widget build(BuildContext context) {
    //final theme = ThemeController.instance;
    return Scaffold(
      backgroundColor: background(),
      floatingActionButton: FloatingActionButton(backgroundColor: ThemeController.instance.primary(), onPressed:() => Navigator.pushNamed(context, AddNotePage.ADD_NOTE_PAGE_ROUTE, arguments: AddNotePageArguments(private: true)),child: Icon(Icons.add, size: 25,), ),
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
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Notas Privadas",
            style: TextStyle(color: fontColor(), fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: StaggeredGridView.countBuilder(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            Note nota;
            if (notes[index].type == TypeNote.Text) {
              nota = notes[index];
              return SimpleCard(nota = notes[index], onTap: () {
                print("Tipo de nota: ${nota.type}");

                Navigator.pushNamed(context, NotePage.NOTE_PAGE_ROUTE,
                    arguments: NotePageArguments(note: nota));
              });
            }
            ;
            if (notes[index].type == TypeNote.Image) {
              nota = notes[index];
              return ImageCard(nota = notes[index], onTap: () {
                print("Tipo de nota: ${nota.type}");

                Navigator.pushNamed(context, NotePage.NOTE_PAGE_ROUTE,
                    arguments: NotePageArguments(note: nota));
              });
            }
            if (notes[index].type == TypeNote.TextImage) {
              nota = notes[index];
              return TextImageCard(nota = notes[index], onTap: () {
                print("Tipo de nota: ${nota.type}");

                Navigator.pushNamed(context, NotePage.NOTE_PAGE_ROUTE,
                    arguments: NotePageArguments(note: nota));
              });
            }
            return Container();
          },
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(1, index.isEven ? 1.3 : 1.9),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1.0,
        )),
      ],
    );
  }
}
