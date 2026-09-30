import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUrl(Uri uri) async {
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    // The host may not have a browser, or the OS may refuse the URL.
  }
}
