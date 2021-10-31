import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ngo_food_help/Screens/donorhome.dart';
import 'package:ngo_food_help/config/Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donorRegistration.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var types = "benecifiary";
  var dtypes = "donor";
  var id;
  void initState() {
    check_login();
    super.initState();
  }
  void check_login() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
      setState(() {
        id =_preferences.getString('userid');
      });

    if(id !=null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DonorHome(id:id)));
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if(id !=null) return Scaffold(
      body:Center(child:CircularProgressIndicator()) ,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Center(
              child: Text(
            "FOOD SHARE",
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1)),
          )),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DonorRegister(type: dtypes)),
                  );
                },
                child: Card(
                  elevation: 2,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.orangeAccent,
                              Colors.amberAccent,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      height: size.height * 0.2,
                      // color: Colors.orangeAccent,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.flag_outlined),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Center(
                              child: Text(
                            'DONOR',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                          )),
                        ],
                      )),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DonorRegister(type: types)),
                  );
                },
                child: Card(
                  elevation: 2,
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        gradient: LinearGradient(
                            colors: [
                              Colors.cyan,
                              Colors.cyanAccent,
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      height: size.height * 0.2,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.emoji_emotions_outlined),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Center(
                              child: Text(
                            'BENEFICIARY',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                          )),
                        ],
                      )),
                )),
          ],
        ));
  }
}
