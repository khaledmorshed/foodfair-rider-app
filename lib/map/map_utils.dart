import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();
  static void launchMapFromSourceToDestination(sourceLatitude, sourceLongitude,
      destinationLatitude, destinationLongitude) async {
    String mapOption = [
      //this is for source
      'saddr=$sourceLatitude,$sourceLongitude',
      //this for destination
      'daddr=$destinationLatitude,$destinationLongitude',
      //this is for accuracy
      'dir_action=navigate',
    ].join('&');

    final mapUrl = 'https://www.google.com/maps?$mapOption';
    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    } else {
      throw "could not launch $mapUrl";
    }
  }
}
