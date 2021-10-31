import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class Loadingcard extends StatefulWidget {

  @override
  _LoadingcardState createState() => _LoadingcardState();
}
class _LoadingcardState extends State<Loadingcard> {
  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        child: Container(
            margin: EdgeInsets.only(left:5, right:5, top: 5, bottom: 2),
            height: MediaQuery.of(context).size.height*0.13,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
            )
        )
    );
  }

}