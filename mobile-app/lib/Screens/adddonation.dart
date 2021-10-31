import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:ngo_food_help/Api/Api.dart';
import 'package:ngo_food_help/Api/urls.dart';
import 'package:ngo_food_help/Screens/donorhome.dart';
import 'package:ngo_food_help/config/color.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDonation extends StatefulWidget {
  final type;
  final datetime;
  final title;
  final des;
  final itemid;
  const AddDonation({Key? key, this.type, this.datetime, this.title, this.des, this.itemid, }) : super(key: key);

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  TextEditingController donationtitle = TextEditingController();
  TextEditingController shortdesc = TextEditingController();
  TextEditingController datetime = TextEditingController();

  List<Asset> images = <Asset>[];
  // File? images;
  // File? Profile;
  // String? filename;
  var now = DateTime.now();
  var formatedate = DateFormat("m-d-yyyy");
  late String currentDate;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool loading = false;
  void initState() {

    setState(() {
      donationtitle.text=widget.title;
      shortdesc.text=widget.des;
      datetime.text=widget.datetime;
      currentDate = formatedate.format(now);
    });
    super.initState();
  }

  var id;
  var type;
  adddonation() async {

    var data = {
      "itemTitle": donationtitle.toString(),
      "itemShortDesc": shortdesc.toString(),
      "dateCreated": DateTime.now().toString(),
      "status": "Submitted",
      "itemExpiryDate": dtime.toString(),
      "audioFilePath": resultt.toString(),
      "attachments": images.toString()
    };

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      id = myPrefs.getString('userid');
      type = myPrefs.getString('usertype');
    });
    print("api call");
    await Api().apicall( Urls().donor + "/" + id + "/donationItems", data,
        context).then((value) {
        print("data is" + value.toString());
        if (value['status'] == 'S') {
        print("data is inserted");
        setState(() {
          loading = true;
          final snackBar = SnackBar(
            content: const Text('Data is Added!'),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DonorHome()),
        );
      } else if (value.toString()== null) {
          print("not inserted");
        final snackBar = SnackBar(
          content: const Text('Data Not Submitted ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
  updateonation() async {

    var updatedata = {
      "itemTitle": donationtitle.toString(),
      "itemShortDesc": shortdesc.toString(),
      "dateCreated": DateTime.now().toString(),
      "status": "Submitted",
      "itemExpiryDate": dtime.toString(),
      "audioFilePath": resultt.toString(),
      "attachments": images.toString()
    };

    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    setState(() {
      id = myPrefs.getString('userid');
      type = myPrefs.getString('usertype');
    });
    print("api call");
    print("itemid"+widget.itemid.toString());
    await Api().call(widget.itemid, updatedata,
        context).then((value) {
      print(" updated data is" + value.toString());
      if (value['status'] == 'S') {
        print("data is updated");
        setState(() {
          loading = true;
          final snackBar = SnackBar(
            content: const Text('Data is updated!'),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DonorHome()),
        );
      } else if (value.toString()== null) {
        print("not inserted");
        final snackBar = SnackBar(
          content: const Text('Data Not updated ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DonorHome()),
                    );
                  },
                  child: Text("CANCEL",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.whitecolor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                ),
              ),
              Text(
                'ADD NEW DONATION',
                style: TextStyle(
                    fontSize: 15,
                    color: Color.whitecolor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5),
              ),
              GestureDetector(
                  onTap: () {
                    widget.type =="old"?
                    updateonation():
                    adddonation();
                  },
                  child:
                  widget.type =="old"?
                  Text(
                    'UPDATE',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.whitecolor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5),
                  ): Text(
                    'SAVE',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.whitecolor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5),
                  )
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: textfield("DONATION TITLE", 0.05, donationtitle),
              ),
              textfield("SHORT DESCRIPTION", 0.1, shortdesc),
              Align(
                  alignment: Alignment(-0.89, 0.8),
                  child: Text(
                    "IMAGES",
                    style: TextStyle(fontSize: 10),
                  )),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                margin: EdgeInsets.only(right: 280, top: 5),
                child: FloatingActionButton(
                    // isExtended: true,
                    child: Icon(Icons.add),
                    backgroundColor: Color.darkbluecolor,
                    onPressed: loadAssets),
              ),
              Container(
                height: 100,
                padding: EdgeInsets.only(left: 15, right: 10, top: 5),
                child: Expanded(
                  child: buildGridView(),
                ),
              ),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment(-0.89, 0.8),
                  child: Text(
                    "EXPIRY DATE",
                    style: TextStyle(fontSize: 10, letterSpacing: 0.5),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _selectDate(),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment(-0.85, 0.8),
                      child: Text(
                        "AUDIO DISCRIPTION",
                        style: TextStyle(fontSize: 10, letterSpacing: 0.5),
                      )),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: GestureDetector(
                          child: Icon(Icons.mic),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          openAudioPicker();
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: resultt == null
                              ? Text("select Audio")
                              : Text(resultt.toString()),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  textfield(title, double height, controller) {
    return Column(
      children: [
        Align(
            alignment: Alignment(-0.89, 0.8),
            child: Text(
              title,
              style: TextStyle(fontSize: 10, letterSpacing: 0.5),
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          height: MediaQuery.of(context).size.height * height,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: TextField(

            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          height: 7,
        )
      ],
    );
  }

  var dtime;
  _selectDate() {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: DateTimePicker(
          style: TextStyle(color: Color.redcolor),
          type: DateTimePickerType.dateTime,
          dateMask: 'MMMM d, yyyy - hh:mm a',
          initialValue: DateTime.now().toString(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          icon: Icon(Icons.event),
          timeLabelText: "Hour",
          selectableDayPredicate: (date) {
            dtime = date;

            // Disable weekend days to select from the calendar
            if (date.weekday == 6 || date.weekday == 7) {
              return false;
            }

            return true;
          },
          onChanged: (val) => print("date=" + val.toString()),
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => print("date=" + val.toString()),
        ));
  }

  String? resultt;

  openAudioPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'WAV', 'AIF'],
    );
    setState(() {
      resultt = result.paths.toString();
    });
    print("result" + result.toString());
  }

  txt(title, double fontsize, color, weight) {
    return Text(
      title,
      style: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: fontsize, color: color, fontWeight: weight)),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      children: List.generate(images.length < 0 ? images.length : 5, (index) {
        if (images.isEmpty)
          return Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Image.asset("assets/images/nullimg.jpg"),
          );
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.only(left: 5),
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      // _error = error;
    });
  }
}
