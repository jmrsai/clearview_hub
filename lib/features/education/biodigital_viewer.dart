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

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/app_colors.dart';

class BioDigitalViewer extends StatefulWidget {
  final String modelId;
  
  const BioDigitalViewer({
    super.key, 
    this.modelId = '52CO', // Default Eye model from the link
  });

  @override
  State<BioDigitalViewer> createState() => _BioDigitalViewerState();
}

class _BioDigitalViewerState extends State<BioDigitalViewer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    final String url = 'https://human.biodigital.com/viewer/?id=${widget.modelId}'
        '&ui-anatomy-descriptions=true'
        '&ui-anatomy-labels=true'
        '&ui-audio=true'
        '&ui-chapter-list=false'
        '&ui-fullscreen=true'
        '&ui-help=true'
        '&ui-info=true'
        '&ui-label-list=true'
        '&ui-layers=true'
        '&ui-loader=circle'
        '&ui-media-controls=full'
        '&ui-menu=true'
        '&ui-nav=true'
        '&ui-search=true'
        '&ui-tools=true'
        '&ui-tutorial=false'
        '&ui-undo=true'
        '&ui-whiteboard=true'
        '&initial.none=true'
        '&disable-scroll=false'
        '&uaid=Lka7U'
        '&paid=o_0b4e4ad7';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('BioDigital WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.cyan,
            ),
          ),
      ],
    );
  }
}
