// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/services.dart';

class Api {
  var httpClient = createHttpClient();

  // Here is the API endpoint we want to hit. This API doesn't have a key but
  // often, APIs do require authentication.
  var url = 'https://flutter.udacity.com/';

  // This is the route we want to hit. Specifically, we are interested in the
  // Currency category.
  var route = 'currency';

  Future<String> get() async {
    var response = await httpClient.get(url + route);
    print(response);
    print('Response status: ${response.statusCode}');
    print(response.body);
    if (response.statusCode != 200) {
      return null;
    }
    return response.body;
  }
}
