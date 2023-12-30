import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepat/src/core/constants/data.dart';
import 'package:notepat/src/core/controllers/theme_controller.dart';
import 'package:notepat/src/ui/pages/add_attachment_page.dart';
import 'package:notepat/src/ui/pages/add_note_page.dart';
import 'package:notepat/src/ui/pages/error_page.dart';
import 'package:notepat/src/ui/pages/export_notes_page.dart';
import 'package:notepat/src/ui/pages/home_page.dart';
import 'package:notepat/src/ui/pages/lading_page.dart';
import 'package:notepat/src/ui/pages/note_page.dart';
import 'package:notepat/src/ui/pages/private_note.dart';
import 'package:notepat/src/ui/pages/search_notes_pages.dart';

void main(){
  ErrorWidget.builder =
      (FlutterErrorDetails details) => ErrorPage(details: details);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: ThemeController.instance.initTheme(), builder: (snapshot,context){
      return MaterialApp(
      routes: {
        HomePage.HOME_PAGE_ROUTE: (context) => HomePage(),
        ErrorPage.ERROR_PAGE_ROUTE: (context) => ErrorPage(),
        LandingPage.LANDING_PAGE_ROUTE: (context) => LandingPage(),
        NotePage.NOTE_PAGE_ROUTE:(context) => NotePage(),
        NotePrivatePage.NOTE_PRIVATE_PAGE_ROUTE:(context) => NotePrivatePage(),
        SearchNotesPage.SEARCH_NOTES_PAGE_ROUTE:(context) => SearchNotesPage(),
        AddNotePage.ADD_NOTE_PAGE_ROUTE:(context) => AddNotePage(),
        AddAttachmentPage.ADD_ATTACHMENT_PAGE_ROUTE: (context) => AddAttachmentPage(),
        ExportNotesPage.EXPORT_NOTES_PAGE_ROUTE: (context) => ExportNotesPage(),
      },
      initialRoute: LandingPage.LANDING_PAGE_ROUTE,
      debugShowCheckedModeBanner: false,
      title: Constants.MAIN_TITLE,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),     
    );
    }); 
    
  }
}

