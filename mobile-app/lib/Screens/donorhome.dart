import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_food_help/Api/Api.dart';
import 'package:ngo_food_help/Api/urls.dart';
import 'package:ngo_food_help/config/color.dart';
import 'package:ngo_food_help/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'adddonation.dart';

class DonorHome extends StatefulWidget {
  final id;
  final type;
  const DonorHome({Key? key, this.id, this.type}) : super(key: key);

  @override
  _DonorHomeState createState() => _DonorHomeState();
}
class _DonorHomeState extends State<DonorHome> {
  bool loading = false;
  var id;
  var type;
  List Allfooods = [];


  registerdata() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      id = myPrefs.getString('userid');
      type = myPrefs.getString('usertype');
    });
    setState(() {
      loading = true;
    });

    print("url =print" + Urls().donor + "/" + id + "/donationItems");

    await Api()
        .getapi(type == 'donor'
            ? Urls().donor + "/" + id + "/donationItems"
            : Urls().beneficiary + "/" + id + "/donationItems?radius=10")
        .then((value) {
      print("data is" + value['data'].toString());
      setState(() {
        Allfooods = value['data'];
      });

    });
  }

  void initState() {
    registerdata();
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content:  const Text('Do you want to exit an App'),
            actions:<Widget>[
              Container(
                height: 35,
                width: 60,
          decoration: BoxDecoration(
            borderRadius:BorderRadius.all(
                Radius.circular(16.0)
            ),
          gradient: LinearGradient(
            colors:[
              Colors.blueAccent,Colors.blue
            ]
          )),
                
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No',style: TextStyle(color: Colors.white)),
                ),
              ),
                Container(
                  height: 35,
                  width: 60,
                  decoration: BoxDecoration(
                      borderRadius:BorderRadius.all(
                          Radius.circular(16.0)
                      ),
                      gradient: LinearGradient(
                          colors:[
                            Colors.blueAccent,Colors.blue
                          ]
                      )),
                  child:TextButton(
                      onPressed: () { exit(0); },
                      child: new Text('Yes',style: TextStyle(color: Colors.white))


                ),
              )

            ],
          ),
        )
      ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.indigo,

              title: Center(
                  child: type == "donor"
                      ? txt(
                          "DONORS HOME", 14, Color.whitecolor, FontWeight.w600)
                      : txt("BENECEFICIARY HOME", 14, Color.whitecolor,
                          FontWeight.w600)),
            ),
            body: ListView.builder(
                itemCount: Allfooods.length > 0 ? Allfooods.length : 5,
                itemBuilder: (BuildContext context, int index) {
                  if (Allfooods.isEmpty) return Loadingcard();
                  return Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left:5,right:5),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        leading: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: CachedNetworkImage(
                            imageUrl: Allfooods[0]['attachments'][0]['url'],
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/nullimg.jpg"),
                          ),
                        ),
                        title: txt(Allfooods[0]['itemTitle'], 12,
                            Color.blackcolor, FontWeight.w600),
                        subtitle: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size
                                          .width*0.5,
                                      child: txt(
                                          Allfooods[0]['itemShortDesc'],
                                          10,
                                          Color.blackcolor,
                                          FontWeight.w600),
                                    ),
                                    SizedBox(width:30,height:5),
                                    type == 'donor'?
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddDonation(type:"old",
                                                    title:Allfooods[0]['itemTitle'],des: Allfooods[0]['itemShortDesc'],datetime:Allfooods[0]['itemExpiryDate'],itemid:Allfooods[0]['itemID'])),
                                        );
                                      },
                                      child: Container(
                                        child: Icon(Icons.arrow_forward_outlined),
                                      ),
                                    ):Container()
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: txt(
                                              "STATUS : ",
                                              10,
                                              Color.blackcolor,
                                              FontWeight.w600),
                                        ),
                                        Container(
                                          child: txt(
                                              Allfooods[0]['status'],
                                              10,
                                              Color.Greencolor,
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Row(
                                      children: [
                                        Container(
                                          child: txt("EXPIRY ON : ", 10,
                                              Color.redcolor, FontWeight.w600),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Flexible(
                                            child: Text(
                                                Allfooods[0]['itemExpiryDate'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10)),
                                          ),
                                          // txt(Allfooods[0]['itemExpiryDate'],10, Color.redcolor,FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                        // trailing:Container(
                        //   height: 700,
                        //   width: 150,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Color.redcolor)
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Icon(Icons.arrow_forward_outlined)
                        //
                        //     ],
                        //   ),
                        // )
                      ),

                      // Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(left:10,right:10),
                      //       child: Container(
                      //         width:MediaQuery.of(context).size.width*0.215,
                      //         height:MediaQuery.of(context).size.height*0.12,
                      //         child:Image.asset("assets/images/donation.jpg",fit: BoxFit.cover,),
                      //       ),
                      //     ),
                      //     Container(
                      //
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //
                      //           Container(
                      //             padding: EdgeInsets.only(left: 5,top:10,bottom: 3),
                      //               child: txt("TITLE", 13, Color.blackcolor, FontWeight.w500)
                      //
                      //           ),
                      //           Container(
                      //               padding: EdgeInsets.only(left: 5),
                      //               child:  txt("DESCRIPTION", 10, Color.blackcolor, FontWeight.w500)
                      //           ),
                      //           Container(
                      //
                      //             margin: EdgeInsets.only(bottom:10,left:220),
                      //             child: IconButton(onPressed: null, icon: Icon(Icons.play_circle_fill)),
                      //           ) ,
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children:[
                      //               Container(
                      //
                      //                   padding: EdgeInsets.only(left: 5,top:25),
                      //                   child: txt("STATUS : ", 11, Color.blackcolor, FontWeight.w500)
                      //               ),
                      //               Container(
                      //                   width: MediaQuery.of(context).size.width*0.2,
                      //                   padding: EdgeInsets.only(top:25),
                      //                   child: txt("SUBMMITTD", 11, Color.Greencolor, FontWeight.w500)
                      //               ),
                      //               Container(
                      //                   width: MediaQuery.of(context).size.width*0.2,
                      //                   padding: EdgeInsets.only(left:30,top:25),
                      //                   child: txt("EXPIRY ON :", 11, Color.redcolor, FontWeight.w500)
                      //               ),
                      //               Container(
                      //
                      //                   padding: EdgeInsets.only(top:25),
                      //                   child:txt("10 OCT 2011", 11, Color.redcolor, FontWeight.w500)
                      //               ),
                      //             ],
                      //
                      //           )
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ),
                  );
                }),
            floatingActionButton: type == "donor"
                ? FloatingActionButton(
                    // isExtended: true,
                    child: Icon(Icons.add),
                    backgroundColor: Color.darkbluecolor,
                    onPressed: () {
                      setState(() {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddDonation(type:"new")),
                        );
                      });
                    },
                  )
                : Container()));
  }

  txt(title, double fontsize, color, weight) {
    return Text(
      title,
      style: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: fontsize, color: color, fontWeight: weight)),
    );
  }
}
