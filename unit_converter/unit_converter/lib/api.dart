// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:flutter/services.dart';

/// The REST API retrieves unit conversions for Categories that change.
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up a API that retrieves a list of currencies and their current
/// exchange rate.
///   GET /currency: get a list of currencies and their description
///   GET /currency/convert: get a conversion from one currency amount to another
// TODO: Do I have to close the http client?
class Api {
  // We use the `http` package. More details: https://flutter.io/networking/
  var httpClient = createHttpClient();

  // Here is the API endpoint we want to hit. This API doesn't have a key but
  // often, APIs do require authentication
  var url = 'flutter.udacity.com';

  // Gets all the categories and conversion rates for the currency Category
  Future<List> getUnits(String category) async {

    // You can directly call httpClient.get() with a String as input,
    // but to make things cleaner, we can pass in a Uri.
    var uri = new Uri.https(url, '/$category');
    var response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      return [];
    }
    var jsonResponse = JSON.decode(response.body);
    try {
      return jsonResponse['units'];
    } on Exception catch (e) {
      // TODO Error UI
      print('Error: $e');
      return [];
    }
  }

  // Given two units, converts them.
  // The fromUnit and toUnit are sent in as the body param
  Future<double> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    var uri = new Uri.https(url, '/$category/convert', {
      'amount': amount,
      'from': fromUnit,
      'to': toUnit
    });
    var response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      return -1.0;
    }
    var jsonResponse = JSON.decode(response.body);
    try {
      return jsonResponse['conversion'].toDouble();
    } on Exception catch (e) {
      // TODO Error UI
      print('Error: $e $jsonResponse["message"]');
      return -1.0;
    }
  }
}
