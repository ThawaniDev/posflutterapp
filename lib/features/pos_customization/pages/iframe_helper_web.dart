import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Web implementation – renders an <iframe> pointing at [url].
Widget buildIframePreview(String url) {
  return HtmlElementView.fromTagName(
    tagName: 'iframe',
    onElementCreated: (Object element) => configureIframeElement(element, url),
  );
}

void configureIframeElement(Object element, String url) {
  final iframe = element as web.HTMLIFrameElement;
  iframe.src = url;
  iframe.style.border = 'none';
  iframe.style.width = '100%';
  iframe.style.height = '100%';
}
