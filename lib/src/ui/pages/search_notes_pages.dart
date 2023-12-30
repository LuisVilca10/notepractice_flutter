import 'package:flutter/material.dart';
import 'package:notepat/src/core/constants/data.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';
import 'package:notepat/src/ui/pages/add_attachment_page.dart';
import 'package:notepat/src/ui/pages/export_notes_page.dart';
import 'package:notepat/src/ui/pages/home_page.dart';
import 'package:notepat/src/ui/pages/note_page.dart';
import 'package:notepat/src/ui/widgets/custom_bottom_sheet/custom_bottom_sheet.dart';
import 'package:notepat/src/ui/widgets/custom_bottom_sheet/custom_bottom_sheet_controller.dart';
import 'package:notepat/src/ui/widgets/custom_tiles/custom_tile.dart';
import 'package:notepat/src/ui/widgets/text_inputs/text_inputs.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

GlobalKey<ScaffoldState> searchNotesPageKey = GlobalKey<ScaffoldState>();

class SearchNotesPage extends StatelessWidget {
  const SearchNotesPage({super.key});
  static final SEARCH_NOTES_PAGE_ROUTE = "search_notes_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.instance.background(),
      key: searchNotesPageKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: fontColor(),)),
      ),
      body: _Body(),
    );
  }
}


class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin{
  late CustomBottomSheetController _controller;
  late TextEditingController _textController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController(text: "");
    _controller=CustomBottomSheetController(this)
    ..addListener((){
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22),
              child: TextInput(
                action: () {},
                icon: Icons.search,
                title: "Buscar notas",
                controller: _textController,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        "Sugeridos",
                        style: TextStyle(
                            color: fontColor(), fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        SimpleTile(
                          title: "Notas compartidas",
                          leading: Icons.share,
                          onTap: () => Navigator.pushNamed(context, ExportNotesPage.EXPORT_NOTES_PAGE_ROUTE),   
                        ),
                        SimpleTile(
                          title: "Tareas",
                          leading: Icons.task,
                          onTap: () => Navigator.pushNamed(
                              context, HomePage.HOME_PAGE_ROUTE),
                        ),
                        SimpleTile(
                          title: "Notas privadas",
                          leading: Icons.lock,
                          onTap: () => _controller.open(),
                        ),
                        SimpleTile(
                          title: "Recursos",
                          leading: Icons.image,
                          onTap: () => Navigator.pushNamed(context,AddAttachmentPage.ADD_ATTACHMENT_PAGE_ROUTE ),
                        )
                      ],
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        "Recientes",
                        style: TextStyle(
                            color: fontColor(), fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ImageTile(
                          onTap: () => Navigator.pushNamed(
                              context, NotePage.NOTE_PAGE_ROUTE,
                              arguments: NotePageArguments(note: notes[index])),
                          title: notes[index].title ?? "",
                          description: notes[index].description ?? "",
                          image: notes[index].image ?? Constants.DEFAULT_IMAGE,
                          date: notes[index].date ?? "",
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        )),
        Transform.translate(offset: Offset(0,size.height+20-(size.height*_controller.value)),child: CustomBottomSheet(close: (){
            _controller.close();
          },),)
      ],
    );
  }
}