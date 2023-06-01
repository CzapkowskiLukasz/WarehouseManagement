import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/views/calendarView.dart';
import 'package:mobile_application/views/homePage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_application/views/mapPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedIndex = 0;

  PageController controller = PageController();

  List<StatefulWidget> pages = [
    const HomePage(),
    const MapPage(),
    const CalendarView(),
  ];

  LinearGradient selectedGradient = mainGradient;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
          });
        },
        controller: controller,
        itemBuilder: (context, position) {
          return pages[selectedIndex];
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor, width: 0.3))),
        child: BottomNavigationBar(
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            controller.jumpToPage(index);
          },
          items: [
            createNavBarItem(LineIcons.home, 'Pulpit'),
            createNavBarItem(LineIcons.map, 'Mapa'),
            createNavBarItem(LineIcons.calendar, "Kalendarz"),
          ],
        ),
      ),
    );
  }

  Column createIcon(String state, IconData icon, String label) {
    if (state == 'active') {
      return Column(
        children: [
          iconGradientMask(mainGradient, icon),
          Text(
            label,
            style: TextStyle(
              foreground: Paint()
                ..shader = selectedGradient.createShader(
                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                ),
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Icon(
            icon,
            color: grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: grey,
            ),
          )
        ],
      );
    }
  }

  BottomNavigationBarItem createNavBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
        activeIcon: createIcon('active', icon, label),
        icon: createIcon('', icon, label),
        label: '');
  }
}
