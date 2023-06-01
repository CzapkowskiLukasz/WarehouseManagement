import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/logo.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/svgAndImages.dart';
import 'package:mobile_application/views/loginPage.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  final UserManagement userManagement = UserManagement();
  late Future<bool?> isIntroShow = userManagement.isIntroShown();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return FutureBuilder(
        future: isIntroShow,
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false) {
              return intro(pageDecoration, width, height);
            } else {
              return const LoginPage();
            }
          } else {
            return intro(pageDecoration, width, height);
          }
        });
  }

  Widget intro(PageDecoration pageDecoration, double width, double height) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Twoje zadania",
          body: "Sprawdzaj przypisane do Ciebie zadania i zarządzaj nimi",
          image: getSvg("assets/clipboard-svgrepo-com.svg", width * 0.5),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Nawigacja",
          body: "Podążaj wygenerowaną trasą aby zebrać całe zamówienie",
          image: getSvg("assets/route-svgrepo-com.svg", width * 0.5),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Skaner kodów kreskowych",
          body:
              "Używaj swojego telefonu jako skanera kodów i już nigdy nie pomyl produktów",
          image: getSvg("assets/barcode-scanner-svgrepo-com.svg", width * 0.5),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Twój planer",
          body:
              "Planuj wolne i sprawdzaj swoją wydajność w zaprojektowanym do tego planerze",
          image: getSvg("assets/calendar-svgrepo-com.svg", width * 0.5),
          footer: SizedBox(
            width: width * 0.6, // <-- match_parent
            height: height * 0.06,
            child: ElevatedButton(
              onPressed: (() => _onIntroEnd(context)),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.05))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: mainGradient,
                    borderRadius: BorderRadius.circular(height * 0.05)),
                child: Container(
                    alignment: Alignment.center,
                    child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: containerPadding),
                        child: Text("Zaczynamy"))),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => ({}),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      showDoneButton: false,
      showBackButton: false,
      showNextButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding:
          kIsWeb ? const EdgeInsets.all(12.0) : const EdgeInsets.all(50),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color.fromRGBO(96, 162, 245, 1),
        activeColor: Color.fromRGBO(138, 237, 246, 1),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
