import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_application/DAL/managers/userManagement.dart';
import 'package:mobile_application/utils/ios/formsIos.dart';
import 'package:mobile_application/utils/shared/logo.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import '../utils/shared/colors.dart';
import '../utils/shared/navigation.dart';
import '../utils/shared/progressBar.dart';
import '../utils/shared/slideableSheet.dart';

import '../utils/shared/text.dart';
import '../utils/shared/toast.dart';

import '../views/mainView.dart';
import '../utils/android/formsAndroid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> with TickerProviderStateMixin {
  late FToast fToast;

  final UserManagement userManagement = UserManagement();
  late Future<String?> userKey = userManagement.isLogged();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  late AnimationController _animationController;

  bool progresShown = false;

  @override
  void initState() {
    userManagement.introShown();
    fToast = FToast();
    fToast.init(context);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: userKey,
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          switch (snapshot.data) {
            case null:
              return returnBody();
            default:
              return const MainView();
          }
        });
  }

  Widget returnBody() {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: BoxDecoration(gradient: mainGradient),
            child: SafeArea(
                minimum: const EdgeInsets.symmetric(
                    horizontal: 2.5 * edgePadding, vertical: 2 * edgePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getLogo(),
                    Stack(
                      children: [
                        cardWithInput(),
                        if (progresShown) cardWithProgress()
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget cardBase(Widget child) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
          width: getWidth(context),
          height: getHeight(context) * 0.4,
          padding: const EdgeInsets.symmetric(
              horizontal: 2 * containerPadding, vertical: containerPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child),
    );
  }

  Widget cardWithProgress() {
    Widget child = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          getText("Logowanie...", cardBasicTextStyle(16, grey)),
          const Spacer(),
          getProgressBar(_animationController, Colors.white),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
    return cardBase(child);
  }

  Widget cardWithInput() {
    Widget child = Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //przycisk, kolumna na karcie
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                getText('Logowanie', cardBasicTextStyle(22, grey)),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: getText(
                      'Wprowadź swój numer telefonu oraz otrzymane hasło.',
                      cardBasicTextStyle(11, grey)),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(containerPadding),
                child: getInput(context, 'Numer telefonu', 'phoneNumber',
                    LineIcons.mobilePhone, phoneNumberController),
              ),
              getInput(context, 'Hasło', 'password', LineIcons.key,
                  passwordController),
              Padding(
                padding: const EdgeInsets.only(
                    top: 2 * containerPadding,
                    left: 2 * containerPadding,
                    right: 2 * containerPadding,
                    bottom: containerPadding),
                child: SizedBox(
                  width: getWidth(context) * 0.4, // <-- match_parent
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      var isLogginSuccesfull = userManagement.login(
                          phoneNumberController.text,
                          passwordController.text,
                          context);
                      setState(() {
                        progresShown = true;
                      });
                      isLogginSuccesfull.then((value) {
                        if (value == true) {
                          moveToNewCleanPage(context, const MainView(), false);
                        } else {
                          setState(() {
                            progresShown = false;
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius))),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: mainGradient,
                          borderRadius: BorderRadius.circular(borderRadius)),
                      child: Container(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: containerPadding),
                              child: Center(
                                child: getText('Zaloguj się',
                                    cardBasicTextStyle(16, Colors.white)),
                              ))),
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  textStyle: TextStyle(
                      foreground: Paint()
                        ..shader = mainGradient.createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                        ),
                      fontSize: 14),
                ),
                onPressed: () {
                  if (phoneNumberController.text.isEmpty) {
                    errorToast('Wprowadź numer telefonu', fToast);
                  } else {
                    var resetStatus = userManagement.resetPassword(
                        phoneNumberController.text, fToast);
                    resetStatus.then((value) {
                      if (value == true) {
                        doneToast('Sprawdź swój adres e-mail', fToast);
                      } else {
                        errorToast('Wystąpił błąd', fToast);
                      }
                    });
                  }
                },
                child: const Text('Przypomnij hasło'),
              ),
            ],
          )
        ]);
    return cardBase(child);
  }

  Widget getInput(BuildContext context, String label, String type,
      IconData icon, TextEditingController controler) {
    if (Platform.isAndroid) {
      return getAndroidBasicTextField(context, label, type, icon, controler);
    } else if (Platform.isIOS) {
      return getIosBasicTextField(context, label, type, icon, controler);
    }

    return getIosBasicTextField(context, label, type, icon, controler);
  }
}
