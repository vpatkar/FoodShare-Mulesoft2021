import 'dart:convert';
import 'dart:io';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:amazon_s3_cognito/image_data.dart';
import 'package:aws_s3/aws_s3.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngo_food_help/Api/Api.dart';
import 'package:ngo_food_help/Screens/donorhome.dart';
import 'package:ngo_food_help/config/color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/urls.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class DonorRegister extends StatefulWidget {

  final type;
  const DonorRegister({Key? key, required this.type}) : super(key: key);

  @override
  _DonorRegisterState createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {


  TextEditingController orgname = TextEditingController();
  TextEditingController orgregisterno = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController email = TextEditingController();

  bool loading=false,logstatus=false;
  String? imagespath;
  File? Profile;
  String? filename;
  String radioButtonItem = 'ONE';
  int id = 1;
  // String? poolId = "AKIATCS72RIQW6MWIXWO";
  // String? awsFolderPath="donor/benecifiarylogo";
  // String? bucketName="donation-item-bucke";
  String? deviceid;
  var donorid;
  var beneficiaryid;

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((token){
      setState(() {
        deviceid=token;
      });
    });
    super.initState();
  }
  void uploadSingleImage() async {

    String bucketName = "- donation-item-bucket";
    String cognitoPoolId = "AKIATCS72RIQW6MWIXWO";
    String bucketRegion = "AwsRegion.AP_SOUTH_1";
    String bucketSubRegion = "AP_SOUTH_1";

    //fileUploadFolder - this is optional parameter
    String fileUploadFolder =
        "donor/benecifiarylogo";

    String filePath = Profile!.path.toString();
    //path of file you want to upload
    ImageData imageData = ImageData("donationimg", filePath,
        uniqueId: "087121", imageUploadFolder: fileUploadFolder);

    //result is either amazon s3 url or failure reason
    String? result = await AmazonS3Cognito.upload(
        bucketName, cognitoPoolId, bucketRegion, bucketSubRegion, imageData,
        needMultipartUpload: true);
    //once upload is success or failure update the ui accordingly

  }

  registerdata()async {

    var data = {
    "donorDeviceToken": deviceid.toString(),
    "firstName":  firstname.toString(),
    "lastName": lastname.toString(),
    "mobileNumber": mobilenumber.toString(),
    "emailAddress": email.toString(),
    "establishmentName": orgname != null ? orgname.toString():null,
    "establishmentRegistrationNumber" :orgregisterno != null ? orgregisterno.toString():null,
    "establishmentLogoURL" : Profile!.path.toString(), "establishmentState": state,
    "establishmentCountry": country,
    "establishmentCity": city.toString(),
    "establishmentStreet": address.toString(),
    "establishmentPinCode": zipcode.toString(),
    "latitude": lat,
    "longitude": lng
    };



    setState(() {
      loading=true;
    });
    print("api call");
    await Api().apicall(widget.type=='donor'? Urls().donor:Urls().beneficiary,data,context).then((value) {
      print("data is"+ value['data']['donorID'].toString());
      if(value['status']=='S'){
          setState(() {
            widget.type=='donor'?
          addStringToSF(value['data']['donorID'].toString())
            :
         addStringToSF(value['data']['beneficiaryID'].toString())
            ;
            loading= false;
          });
          print("data inserted successful");
          final snackBar = SnackBar(
            content: const Text('Data is Submitted ! '),
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


      }else if(value==null){
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
  addStringToSF(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid',id);
    prefs.setString('usertype',widget.type);
    print(prefs.getString('userid').toString());
    print(prefs.getString('usertype').toString());

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DonorHome()),
    );
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          title: widget.type == "donor"
              ? Center(
                  child: Text(
                  "DONOR REGISTRATION",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ))
              : Center(
                  child: Text(
                  "BENECIFIARY REGISTRATION",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                )),
        ),
        body: loading == true ?
         Center(child: CircularProgressIndicator())
        :SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 15),
                    alignment: Alignment(-0.89, 0.8),
                    child: Text("Registration Type".toUpperCase(),
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 11,letterSpacing: 0.5)
                        ))),
                Row(
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'ONE';
                          id = 1;
                        });
                      },
                    ),
                    Text(
                      'Organization',
                      style: new TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w300),
                    ),

                    Radio(
                      value: 2,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'ONE';
                          id = 2;
                        });
                      },
                    ),
                    Text(
                      'Individual',
                      style: new TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w300),
                    ),

                  ],
                ),
                id == 1 ? textfield(" ORGANIZATION NAME",orgname,50) : Container(),
                id == 1
                    ? textfield("   ORGANIZATION REGISTRATION NUMBER",orgregisterno,50)
                    : Container(),
                Container(
                    alignment: Alignment(-0.88, 0.8),
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "PICk YOUR LOCATION",
                      style: TextStyle(fontSize: 10),
                    )),
                GestureDetector(
                  onTap: () {
                    openMap(-3.823216, -38.481700);
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      alignment: Alignment(-0.89, 0.9),
                      child: Icon(Icons.location_on)),
                ),
                textfield("ADDRESS",address,65),
                textfield("CITY",city,50),
                textfield("ZIP CODE",zipcode,50),
                textfield("FIRST NAME",filename,50),
                textfield("LAST NAME",lastname,50),
                textfield("MOBILE NUMBER",mobilenumber,50),
                textfield("EMAIL",email,50),
                Container(
                    alignment: Alignment(-0.88, 0.8),
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "UPLOAD LOGO",
                      style: GoogleFonts.lato(textStyle:TextStyle(fontSize: 10)) ,
                    )),
                GestureDetector(
                  onTap: () {
                    _getFromGallery(ImageSource.gallery);
                  },
                  child: Container(
                      width:size.width*0.9,
                      margin: EdgeInsets.only(left:15,top: 10,bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5,left: 20),

                      alignment: Alignment(-0.89, 0.9),
                      child:
                          Row(children: [
                            Icon(Icons.image_search_outlined),
                            Container(

                              child:Image(
                                width:size.width*0.2,
                                height: size.height*0.1,
                                image: Profile != null
                                    ? Image.file(
                                  Profile!,
                                  fit: BoxFit.cover,
                                ).image
                                    : AssetImage("assets/images/nullimg.jpg"),
                              ),

                            )
                          ])


                  ),
                ),
                registerbtn()
              ]),
        ));
  }

  textfield(title,controller,double height) {
    return Column(
      children: [
        Align(
            alignment: Alignment(-0.89, 0.8),
            child: Text(
              title,
              style: GoogleFonts.lato( textStyle: TextStyle(fontSize: 10,letterSpacing: 0.5)) ,
            )),
        SizedBox(
          height: 5,
        ),
        Container(
          height: height,
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

  registerbtn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
       color: Color.darkbluecolor
      ),

      margin: EdgeInsets.only(left: 15,bottom: 15),
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.07,

      child: ElevatedButton(
          child: Text('REGISTER'),
          onPressed: () {
            setState(() {
                registerdata();
                uploadSingleImage();
            });
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const DonorHome()),
            // );
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              onSurface: Colors.transparent,
              shadowColor: Colors.transparent,
              textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
    );
  }
  String? mapaddress;
  String? country;
  String? state;
  var lat;
  var lng;
  openMap(double latitude, double longitude) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: "AIzaSyCxreoVeTIXYmCF0rtAy3UgeHjoMnsoVGU",   // Put YOUR OWN KEY here.
          onPlacePicked: (result) {
            setState(()  {
                address.text = result.formattedAddress.toString();
                var mapaddress = result.formattedAddress.split(",");
                var maplength =mapaddress.length;
                country = mapaddress[maplength-1];
                city.text = mapaddress[maplength-3];
                var zip = mapaddress[maplength-2].split(" ");
                zipcode.text = zip[2];
                state = zip[1];
                lat = result .geometry.location.lat.toString();
                lng = result .geometry.location.lng.toString();
                print("on pickup location"+result .geometry.location.lat.toString());
            });

            Navigator.of(context).pop();
          },
          initialPosition: LatLng(-33.8567844, 151.213108),
          useCurrentLocation: true,
        ),
      ),
    );
  }
  _getFromGallery(feature) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: feature,
    );
    Profile = File(pickedFile.path);

    final Directory extDir = await getTemporaryDirectory();
    String dirPath = extDir.path;

    final String filePath = dirPath+DateTime.now().microsecondsSinceEpoch.toString()+'.png';

    final File newImage = await Profile!.copy(filePath);
    setState(() {
      if (pickedFile != null) {
        Profile = newImage;
      print("path="+Profile!.path.toString());
      } else {
        print('No image selected.');
      }
    });

  }

}
