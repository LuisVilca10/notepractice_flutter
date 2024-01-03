import 'package:flutter/material.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class TrashPage extends StatelessWidget {
  const TrashPage({super.key});
  static final TRASH_PAGE_ROUTE = "trash_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.instance.background(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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

class _BodyState extends State<_Body> {
  List<Note> notes=[
    note1
  ];  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Papelera", style: TextStyle(color: fontColor(), fontWeight: FontWeight.bold),),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: notes.length,itemBuilder: (context, index){
            return ListTile(
              title: Text(notes[index].title??"", style: TextStyle(color: fontColor()),),
              subtitle: Text(notes[index].description??"",overflow: TextOverflow.ellipsis, style: TextStyle(
                color: ThemeController.instance.brightnessValue ? Colors.black : Colors.grey.shade400
              )),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value==0) {
                    //restaurar

                  }if (value==1) {
                    //eliminar
                  }
                },
                icon: Icon(Icons.more_vert, color: fontColor(),), itemBuilder: (context) => [
                PopupMenuItem(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.restart_alt),
                    //SizedBox(width:20,),
                    Text("Restaurar"),
                  ],
                ), value: 0,),
                PopupMenuItem(child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.delete_forever),
                    Text("Eliminar"),
                  ],
                ), value: 0,)
              ],),
            );
          })
        )
      ],
    );
  }
}