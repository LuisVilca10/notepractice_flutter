import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/ui/widgets/custom_tiles/custom_tile.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue
      ? Colors.black
      : Colors.white;
}

class ExportNotesPage extends StatelessWidget {
  const ExportNotesPage({super.key});
  static final EXPORT_NOTES_PAGE_ROUTE = "export_note_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.instance.background(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: fontColor(),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  Widget _card(String title, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(icon, color: fontColor(),size: 40,),
                Text(title, style: TextStyle(color: fontColor(), fontSize: 16),)
              ],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 3.9 : 1.3),
          mainAxisSpacing: 1,
          crossAxisSpacing: 1.0,
          crossAxisCount: 2,
          itemCount: 1,
          itemBuilder: (context, index) {
           return Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/documentos.png"))),
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
              "Rapidamente exporta y \n comparte notas",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: fontColor()),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(flex: 2,child: _card("PDF", Icons.picture_as_pdf_rounded, () => null)),
                  Flexible(flex: 2,child: _card("Notas", Icons.note_alt_sharp, () => null)),
                  Flexible(flex: 2,child: _card("PDF", Icons.image, () => null)),
                ],
              ),
            ),
            Column(
              children: [
                Divider(),
            SimpleTile(
              title: "Copy Notes",
              onTap: (){},
              trailing: Icons.copy,
            ),
            SimpleTile(
              title: "Guardar Atchivos",
              onTap: () {
                
              },
              trailing: Icons.save,
            )
              ],
            )
              ],
            ),
          )
        ],
      );
          }
       
    );
  }
}
