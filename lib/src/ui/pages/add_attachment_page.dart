import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepat/src/core/constants/data.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/ui/widgets/buttons/simple_buttons.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class AddAttachmentPage extends StatelessWidget {
  const AddAttachmentPage({super.key});
  static final ADD_ATTACHMENT_PAGE_ROUTE = "add_attachment_page";

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    return Scaffold(
      backgroundColor: theme.background(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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

class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<dynamic> images = [];

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/folder.png"),
                        fit: BoxFit.cover)),
              )),
          Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    images.length == 0 ? "Sin Recursos" : "Mis Recursos",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: fontColor()),
                  ),
                  //SizedBox(height: 10,)
                  Expanded(
                      child: images.length == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  Constants.CONTENT_ATTACHMENT,
                                  style: TextStyle(color: Colors.grey.shade300),
                                  textAlign: TextAlign.center,
                                ),
                                MediumButton(
                                  title: "Agregar",
                                  icon: Icons.add,
                                  onTap: () {},
                                  primaryColor: false,
                                )
                              ],
                            )
                          : StaggeredGridView.countBuilder(
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return _ImageCard(images[index]);
                              },
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      1, index.isEven ? 1 : 1.3),
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1.0,
                            ))
                ],
              ))
        ],
      ),
    );
  }
}


class _ImageCard extends StatelessWidget {
  final String image;
  const _ImageCard(this.image,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(image))
      ),
    );
  }
}