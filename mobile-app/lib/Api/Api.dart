import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ngo_food_help/Api/urls.dart';
var dio = new Dio();
class Api{

  Future<Map<String, dynamic>> apicall(apiname,params,context) async {
    try{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("url=" + Urls().baseurl + apiname);
        print("send data to server=" + jsonEncode(params));
        var response = await dio.post(Urls().baseurl + apiname,data:params);

        return response.data;

      }else{
        final snackBar = SnackBar(
          content: const Text('Check Your Internet ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }catch(err) {
      print("error="+err.toString());

    }
  return {"status": "n", "message": "Donor Registered failed", "data": {}};
  }
  Future<Map<String, dynamic>> call(apiname,params,context) async {
    try{
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("url=" + Urls().baseurl+"donationItems/" + apiname);
        print("send data to server=" + jsonEncode(params));
        var response = await dio.put(Urls().baseurl+"donationItems/"+ apiname,data:params);

        return response.data;

      }else{
        final snackBar = SnackBar(
          content: const Text('Check Your Internet ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }catch(err) {
      print("error="+err.toString());

    }
    return {"status": "n", "message": "update failed", "data": {}};
  }
  getapi(apiname) async {
    try{
      var response = await dio.get( Urls().baseurl +apiname);
      var data = response.data;

      return data;


    }catch(err) {
      print("error="+err.toString());
      return null;
    }

  }
}








