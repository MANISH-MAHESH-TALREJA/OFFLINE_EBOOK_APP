import 'package:flutter/material.dart';

import '../helper/color_constants.dart';
import '../helper/strings.dart';
import '../localization/demo_localization.dart';

class AboutUs extends StatefulWidget
{
  const AboutUs({super.key});

  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: darkMode ? ColorsRes.white : ColorsRes.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(DemoLocalization.of(context).translate("aboutUs"), style: const TextStyle(fontFamily: 'Poppins'),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            right: 15,
            left: 10,
          ),
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.0,
                color: darkMode ? ColorsRes.black : Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: DemoLocalization.of(context).translate("welcome"),
                  style: const TextStyle(fontFamily: 'Poppins')
                ),
                TextSpan(
                  text: DemoLocalization.of(context)
                      .translate("welcomeText"),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins'
                  ),
                ),
                TextSpan(
                  text: DemoLocalization.of(context).translate(
                      "appAuthorDescription"),style: const TextStyle(fontFamily: 'Poppins')
                ),
                TextSpan(
                  text: DemoLocalization.of(context)
                      .translate("madeBy"),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'Poppins'
                  ),
                ),
                TextSpan(
                  text: DemoLocalization.of(context).translate("developer"),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
