import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_food_help/Screens/donorhome.dart';
import 'package:ngo_food_help/Screens/donorregistration.dart';
import 'package:ngo_food_help/config/Color.dart';

import 'home.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:AnimatedSplashScreen(
                splashIconSize: 200,
                backgroundColor: Color.whitecolor,
                splash: Container(
                    width: 500,
                    child: Column(
                      children: [
                        Container(

                          height:MediaQuery.of(context).size.height*0.15,
                          width:MediaQuery.of(context).size.width*0.3,

                          child:CircleAvatar(
                            radius: 45,
                            child:
                            ClipOval(
                              child: Image.asset(
                                "assets/images/logo.jpeg",
                                fit:BoxFit.cover,
                                height:150,
                                width:150 ,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Center(child:
                        Text('FOOD  SHARE',style:
                        GoogleFonts.lato(
                            textStyle: TextStyle(color:Color.blackcolor,fontSize: 18,fontWeight: FontWeight.bold,letterSpacing:0.5))
                        ),

                        ),
                      ],
                    )


                ),


                // Center(child:
                // Text('FOOD  SHARE',style:
                // GoogleFonts.lato(
                //   textStyle: TextStyle(color:Color.whitecolor,fontSize: 20,fontWeight: FontWeight.bold,letterSpacing:0.5))
                // ),
                //
                // ),
                splashTransition:SplashTransition.scaleTransition,
                nextScreen: Home(),
              ),




    );
  }
}
