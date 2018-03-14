// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up a API that retrieves a list of currencies and their current
/// exchange rate.
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  // We use the `dart:io` HttpClient. More details: https://flutter.io/networking/
  final httpClient = HttpClient();

  /// The API endpoint we want to hit.
  ///
  /// This API doesn't have a key but often, APIs do require authentication
  final url = 'flutter.udacity.com';

  /// Gets all the units and conversion rates for a given category.
  ///
  /// [category] is the category from which to retrieve units.
  /// Returns a list. Prints exception silently.
  Future<List> getUnits(String category) async {
    final uri = Uri.https(url, '/$category');
    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) {
        return null;
      }
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);
      try {
        return jsonResponse['units'];
      } on Exception catch (e) {
        print('Error: $e');
        return null;
      }
    } on Exception catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount.
  Future<double> convert(
      String category, String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(url, '/$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});
    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) {
        return null;
      }
      final responseBody = await response.transform(utf8.decoder).join();
      final jsonResponse = json.decode(responseBody);
      try {
        return jsonResponse['conversion'].toDouble();
      } on Exception catch (e) {
        print('Error: $e $jsonResponse["message"]');
        return null;
      }
    } on Exception catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
