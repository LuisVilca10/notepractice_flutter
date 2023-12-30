import 'package:flutter/material.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/core/models/note.dart';
import 'package:notepat/src/ui/widgets/buttons/simple_buttons.dart';
import 'package:notepat/src/ui/widgets/text_inputs/text_inputs.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class AddNotePageArguments {
  final bool edit;
  final bool private;
  final Note? note;
  AddNotePageArguments({this.edit = false, this.private = false, this.note});
}

final defaultArguments = AddNotePageArguments();

class AddNotePage extends StatelessWidget {
  const AddNotePage({Key? key}) : super(key: key);

  static final ADD_NOTE_PAGE_ROUTE = "add_note_page";

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    AddNotePageArguments arguments;
    arguments = ModalRoute.of(context)?.settings.arguments != null
        ? ModalRoute.of(context)?.settings.arguments as AddNotePageArguments
        : defaultArguments;
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        title: Text(
          "Nueva Nota",
          style: TextStyle(color: fontColor()),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: fontColor()),
            onPressed: () => Navigator.pop(context)),
      ),
      body: _Body(arguments),
    );
  }
}

class _Body extends StatefulWidget {
  final AddNotePageArguments arguments;
  const _Body(this.arguments, {Key? key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late TextEditingController _title;
  late TextEditingController _description;

  String? image;

  Note note = Note();
 // final ImagePicker _picker = ImagePicker();

 // FirebaseServices _services = FirebaseServices.instance;

  String parseDate() {
    final date = DateTime.now();
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  void initState() {
    if (widget.arguments.edit) {
      note = widget.arguments.note!;
      _title = TextEditingController(text: note.title ?? "no hay");
      _description = TextEditingController(text: note.description ?? "");
    } else {
      _title = TextEditingController(text: "");
      _description = TextEditingController(text: "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextInput(title: "Titulo", controller: _title),
          LargeTextInput(title: "Descripción", controller: _description),
          image != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(image!),
                    leading: Icon(Icons.file_present_outlined),
                  ),
                )
              : SizedBox(),
          Row(
            children: [
              Flexible(
                child: MediumButton(
                  title: "Camara",
                  icon: Icons.camera,
                  onTap: () async {
                   /* try {
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (photo != null) setState(() => image = photo.path);
                    } catch (e) {}*/
                  },
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: MediumButton(
                  title: "Galeria",
                  icon: Icons.image,
                  onTap: () async {
                    /*try {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        setState(() => image = result.files.single.path);
                      }
                    } catch (e) {}*/
                  },
                  primaryColor: false,
                ),
              ),
            ],
          ),
          Spacer(),
          MediumButton(
            title: "Guardar",
            onTap: () async {
              note.title = _title.value.text;
              note.description = _description.value.text;
              note.private = widget.arguments.private;
              /*if (image != null) {
                final Map<String, dynamic> response =
                    await _services.uploadImage(File(image!));
                print(response["status"]);
                if (response["status"] == StatusNetwork.Connected) {
                  print("url:"+response["data"]);
                  note.image = response["data"];
                  note.type = TypeNote.Image;
                }
              }*/

              final Map<String, dynamic> response;
              final Map<String, dynamic> values = {
                "date": parseDate(),
                "description": note.description,
                "image": note.image,
                "private": note.private,
                "state": note.state.toString(),
                "title": note.title,
                "type": note.type.toString(),
              };

              /*if (widget.arguments.edit) {
                response = await _services.update("notes", note.id!, values);
              } else {
                response = await _services.create("notes", values);
              }

              switch (response["status"]) {
                case StatusNetwork.Connected:
                  print("Se adiciono correctamente");
                  break;
                case StatusNetwork.Exception:
                  print("No se adiciono correctamente");
                  break;
                case StatusNetwork.NoInternet:
                  print("No hay una conexion a internet");
                  break;
                default:
                  print("Ocurrio un error");
                  break;
              }*/
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}