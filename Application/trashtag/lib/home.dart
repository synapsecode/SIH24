import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashtag/auth/login.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:trashtag/binocculars/addbindialog.dart';
import 'package:trashtag/binocculars/binocculars.dart';
import 'package:trashtag/extensions/miscextensions.dart';
import 'package:trashtag/services/locationservice.dart';
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

  final screens = [
    const TrashTagFragment(key: ValueKey('TT')),
    const BinOcculars(
      key: ValueKey('BINOC'),
    )
  ];

  getContent() {
    if (pageIndex == 0) {
      return screens[0];
    } else if (pageIndex == 1) {
      return screens[1];
    }
    return const SizedBox();
  }

  TextEditingController serverLinkController = TextEditingController();

  Widget getFAB() {
    if (pageIndex == 1) {
      return FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if (LocationService.currentUserPosition == null) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDustbinDialog(
                currentLocation: LocationService.currentUserPosition!,
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ).addRightMargin(MediaQuery.of(context).size.width - 80);
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: getFAB(),
      appBar: AppBar(
        title: Text(
          appBar,
          style: TextStyle(color: Colors.white),
        ),
        leading: appBarLogo,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('x-user');
                print('Logged Out!');
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }),
                  (route) => false,
                );
              }),
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showCreditsDialog(context);
            },
          ),
        ],
        backgroundColor: Colors.green,
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
          GButton(icon: Icons.leaderboard, text: 'Leaderboard'),
        ],
      ),
    );
  }

  void showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/2.png'),
                SizedBox(height: 20),
                Text(
                  'TrashTag App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'SIH 2024 Submission',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Developed by:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 0,
                  children: [
                    _buildChip('Manas'),
                    _buildChip('Somnath'),
                    _buildChip('Koushik'),
                    _buildChip('Daksh'),
                    _buildChip('Sahil'),
                    _buildChip('Ishija'),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(String name) {
    return Chip(
      label: Text(name),
      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: Colors.teal,
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
