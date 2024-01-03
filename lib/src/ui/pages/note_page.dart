import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notepat/src/core/constants/data.dart';
import 'package:notepat/src/core/constants/parameters.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';
import 'package:notepat/src/core/services/file_services.dart';
import 'package:notepat/src/ui/pages/add_note_page.dart';
import 'package:notepat/src/ui/widgets/buttons/simple_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class NotePageArguments {
  final Note? note;
  NotePageArguments({this.note});
}

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class NotePage extends StatelessWidget {
  NotePage({super.key});
  static const NOTE_PAGE_ROUTE = "note_page";

  String _title(Note note) {
    if (note.title != null) {
      return note.title!;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    NotePageArguments arguments =
        ModalRoute.of(context)?.settings.arguments as NotePageArguments;
    print(arguments);
    final theme = ThemeController.instance;
    final note = arguments.note;
    print("Tipo de nota: ${note?.type}");
    return Scaffold(
      backgroundColor: theme.background(),
      floatingActionButton: (note?.type == TypeNote.Text ||
              note?.type == TypeNote.Network ||
              note?.type == TypeNote.TextNetwork)
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(
                  context, AddNotePage.ADD_NOTE_PAGE_ROUTE,
                  arguments:
                      AddNotePageArguments(note: arguments.note, edit: true)),
              child: Icon(Icons.edit),
            )
          : Container(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: fontColor()),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _title(arguments.note!),
          style: TextStyle(color: fontColor()),
        ),
        actions: [
          /* IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: fontColor(),
              )),*/
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade400,
              ))
        ],
      ),
      body: _Body(
        arguments.note!,
      ),
      //forma 2
      /*
      //appBar: AppBar(automaticallyImplyLeading: false, leading: IconButton( icon: Icon(Icons.arrow_back_ios, color: fontColor()), onPressed: () => Navigator.pop(context),    ), elevation: 0, backgroundColor: Colors.transparent, centerTitle: true, title: Text(_title(arguments.note!), style: TextStyle(color: fontColor()),),), 
      body: Container(margin: EdgeInsets.only(top: 50), child: _Body(arguments.note!,)) ,
       */
    );
  }
}

class _Body extends StatefulWidget {
  final Note note;
  _Body(this.note, {super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _repaintKey = GlobalKey();
  Uint8List? listBytes;

  Widget _image(BuildContext context) {
    NotePageArguments arguments =
        ModalRoute.of(context)?.settings.arguments as NotePageArguments;
    if (widget.note.type == TypeNote.Image ||
        widget.note.type == TypeNote.ImageNetwork ||
        widget.note.type == TypeNote.TextImage ||
        widget.note.type == TypeNote.TextImageNetwork) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(widget.note.image ?? Constants.DEFAULT_IMAGE),
              fit: BoxFit.cover,
            )),
            //child: Container(child:ElevatedButton(onPressed: (){}, child: Icon(Icons.edit)),),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(
                    0.5), // Cambia este color según tus necesidades
                borderRadius: BorderRadius.circular(60),
              ),
              transform: Matrix4.translationValues(-5, -25.0, 0.0),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(
                    context, AddNotePage.ADD_NOTE_PAGE_ROUTE,
                    arguments:
                        AddNotePageArguments(note: arguments.note, edit: true)),
                icon: Icon(Icons.mode_edit_outline_outlined),
                iconSize: 40,
              )),
        ],
      );
    }
    return Container();
  }

  void urls(String text) {
    widget.note.urls = [];
    RegExp regexp =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> match = regexp.allMatches(text);
    match.forEach((element) {
      widget.note.urls?.add(text.substring(element.start, element.end));
    });
  }

  String parseDate() {
    if (widget.note.date != null) {
      final _date = widget.note.date?.split("-");
      return "${_date?[0]} de ${Constants.NAME_MONTH[int.parse(_date![1])]} del ${_date[2]}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    urls(widget.note.description ?? "");
    return Container(
      child: Column(
        children: [
          RepaintBoundary(
            key: _repaintKey,
            child: Column(
              children: [
                _image(context),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(
                        widget.note.description ?? "no hay texto",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: fontColor()),
                      ),
                      Text(
                        parseDate(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: fontColor()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.note.urls!.length,
            itemBuilder: (context, index) {
              final url = widget.note.urls![index];
              return ListTile(
                onTap: () {
                  launch(url);
                },
                title: Text(
                  widget.note.urls![index],
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blue),
                ),
              );
            },
          )),
          
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: MediumButton(
              title: "Descargar",
              onTap: () async {
                final RenderRepaintBoundary render = _repaintKey.currentContext!
                    .findRenderObject() as RenderRepaintBoundary;
                final image = await render.toImage();
                final bytes = await image.toByteData(format: ImageByteFormat.png);
                listBytes= bytes!.buffer.asUint8List();
                if (listBytes!=null) {
                 await  FileServices.instance.saveBytes("capturas.png", listBytes!);
                }
               
              },
            ),
          )
        ],
      ),
    );
  }
}
