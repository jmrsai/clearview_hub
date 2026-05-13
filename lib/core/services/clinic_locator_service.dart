/*
 * Copyright 2026 ClearView Hub Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class ClinicLocatorService {
  ClinicLocatorService._();
  static final ClinicLocatorService instance = ClinicLocatorService._();

  Future<void> findNearbyClinics() async {
    final query = Uri.encodeComponent('eye clinic ophthalmologist');
    Uri url;

    if (Platform.isAndroid) {
      url = Uri.parse('geo:0,0?q=$query');
    } else if (Platform.isIOS) {
      url = Uri.parse('maps://?q=$query');
    } else {
      url = Uri.parse('https://www.google.com/maps/search/$query');
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback to web search if map apps aren't available
      final webUrl = Uri.parse('https://www.google.com/maps/search/$query');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    }
  }
}
