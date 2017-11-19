// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

// The REST API retrieves unit conversions for Categories that change.
// For example, the currency exchange rate, stock prices, the height of the
// tides change often.
// We have set up a API that retrieves a list of currencies and their current
// exchange rate.
// To get a list of currencies and their description, you would make a GET
// call to /currency
// To get a conversion from one currency to another, you would make a GET
// call to /currency/convert
// TODO: Do I have to close the http client?
class Api {
  // We use the `http` package. More details: https://flutter.io/networking/
  var httpClient = createHttpClient();

  // Here is the API endpoint we want to hit. This API doesn't have a key but
  // often, APIs do require authentication
  // TODO You can use your localhost too. See the server.js file for details.
  var url = 'https://flutter.udacity.com';

  //var url = 'https://localhost:8000';

  // Gets all the categories and conversion rates for the currency Category
  Future<List> getUnits(String category) async {
    var response = await httpClient.get('$url/$category');
    if (response.statusCode != 200) {
      return [];
    }
    // TODO add error handling
    return JSON.decode(response.body)['units'];
  }

  // Given two units, converts them.
  // The fromUnit and toUnit are sent in as the body param
  Future<double> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    var response = await httpClient
        .get('$url/$category/convert?amount=$amount&from=$fromUnit%to=$toUnit');
    // TODO add error handling
    if (response.statusCode != 200) {
      return null;
    }
    // TODO add error handling
    return double.parse(JSON.decode(response.body)['conversion']);
  }
}
