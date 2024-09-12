import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trashtag/trashtag.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  var url = Uri.parse('https://github.com/synapsecode/TrashTrace-MiniProject');
  var murl = Uri.parse('https://www.instagram.com/somu_7704/');

  final Map<int, String> appBarTitles = {
    0: 'TrashTag',
    1: 'BinOcculars',
  };

  final Map<int, Widget> pageLogos = {
    0: Image.asset('assets/TrashTagLogo.png'),
    1: Image.asset('assets/BinOccularsLogo.png'),
  };

  String appBar = 'TrashTag';
  Widget appBarLogo = Image.asset('assets/TrashTagLogo.png');

  getContent() {
    if (pageIndex == 0) {
      return TrashTagFragment();
    } else if (pageIndex == 1) {
      return const SizedBox();
    }
    return const SizedBox();
  }

  TextEditingController serverLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBar),
        leading: appBarLogo,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () {}),
        ],
        backgroundColor: Colors.cyan[200],
      ),
      body: getContent(),
      bottomNavigationBar: GNav(
        selectedIndex: pageIndex,
        backgroundColor: Colors.green,
        color: Colors.white,
        activeColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBackgroundColor: const Color.fromARGB(138, 14, 99, 17),
        onTabChange: (i) {
          pageIndex = i;
          setState(() {
            pageIndex = i;
            appBar = appBarTitles[i]!;
            appBarLogo = pageLogos[i]!;
          });
        },
        gap: 7,
        padding: const EdgeInsets.all(16),
        tabMargin: const EdgeInsets.all(5),
        tabs: const [
          GButton(icon: Icons.qr_code_scanner, text: 'TrashTag'),
          GButton(icon: Icons.pin_drop_rounded, text: 'BinOcculars'),
        ],
      ),
    );
  }
}
