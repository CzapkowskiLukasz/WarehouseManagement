import 'package:flutter/material.dart';
import 'package:mobile_application/DAL/managers/sharedPreferences.dart';
import 'package:mobile_application/DAL/managers/taskManagement.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/navigation.dart';
import 'package:mobile_application/utils/shared/numeric.dart';
import 'package:mobile_application/utils/shared/text.dart';
import 'package:mobile_application/views/mainView.dart';

class ConfirmationView extends StatefulWidget {
  const ConfirmationView({Key? key, required this.id}) : super(key: key);

  final int id;
  @override
  _ConfirmationViewState createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  final SharedPreferencesManagement preferences = SharedPreferencesManagement();

  final TaskManagement taskManagement = TaskManagement();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    gradient: mainGradient,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: (width * 0.25) - 6,
                  height: (width * 0.25) - 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                iconGradientMaskWithSize(
                    mainGradient, Icons.done_sharp, width * 0.2),
              ],
            ),
            Padding(
              padding: paddingEdge,
              child: getMainTextCentered(
                  'Wszystkie produkty zostały zebrane, naciśnij przycisk aby kontynuować',
                  context),
            ),
            SizedBox(
              width: width * 0.7,
              height: height * 0.08,
              child: ElevatedButton(
                onPressed: (() {
                  taskManagement.setAssignmentState(widget.id, 3);
                  removeTaskId();
                  moveToNewCleanPage(context, const MainView(), false);
                }),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: containerPadding),
                          child: Text(
                            "Kontynuuj pracę",
                            style: TextStyle(fontSize: 16),
                          ))),
                ),
              ),
            ),
          ]),
    );
  }

  void removeTaskId() async {
    await preferences.removeAssingmentId();
  }
}
