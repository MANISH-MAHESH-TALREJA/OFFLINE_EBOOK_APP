import 'package:flutter/material.dart';

import '../helper/color_constants.dart';
import '../helper/strings.dart';
import '../localization/demo_localization.dart';

class TermsAndConditions extends StatefulWidget
{
  const TermsAndConditions({super.key});

  @override
  TermsAndConditionsState createState() => TermsAndConditionsState();
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? ColorsRes.white : ColorsRes.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DemoLocalization.of(context).translate("Terms & Conditions"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
          ),
          child: RichText(
            text: TextSpan(
              style:  TextStyle(
                fontSize: 16.0,
                color: darkMode ? ColorsRes.black : Colors.white,
              ),
              children: <TextSpan>[
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                  style:  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                  style:  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01 ",
                  ),
                  style:  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                  style:  const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 TextSpan(
                  text: DemoLocalization.of(context).translate(
                    "text01",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
