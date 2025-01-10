import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Infopage extends StatelessWidget {
  const Infopage({super.key});

  Future<void> dialNumber({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);

    try {
      // Launch the dialer
      if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
        print("Dialing: $phoneNumber");
      } else {
        throw Exception("Cannot dial number");
      }
    } catch (e) {
      print("Error launching dialer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to call $phoneNumber")),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Page Not Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    // ignore: unused_local_variable
    final dividerColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 80,
              width: 80,
              child: Image.asset("images/Cubosquare-logo.png"),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "At Cubosquare, we specialize in transforming your ideas into reality. Whether you're looking for a SAAS, CRM, AI solution, web development, or mobile app, our expert team delivers tailored solutions to bring your vision to life. Like and share with your loved ones and let us help turn your dreams into innovation.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _openUrl('https://www.cubosquare.com/'),
                child: Image.asset(
                  "images/world-wide-web.png",
                  height: 35,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => _openUrl('https://x.com/cubosquare'),
                child: Image.asset(
                  "images/twitter.png",
                  height: 35,
                ),
              ),
              GestureDetector(
                onTap: () => _openUrl('https://www.facebook.com/CUBOSQUARE/'),
                child: Image.asset(
                  "images/facebook.png",
                  height: 35,
                ),
              ),
              GestureDetector(
                onTap: () => _openUrl('https://www.instagram.com/cubosquare/'),
                child: Image.asset(
                  "images/instagram.png",
                  height: 35,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    dialNumber(phoneNumber: '+918652083868', context: context),
                child: Image.asset(
                  "images/phone-call.png",
                  height: 35,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "We greatly appreciate your support. You can donate to support our social initiatives and contribute to our mission. Your one review means a lot to us.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final donateUrl = 'https://www.cubosquare.com/contact/';
                  _openUrl(donateUrl);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDarkMode ? Colors.amber : Colors.green,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      color: isDarkMode ? Colors.amber : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "DONATE",
                      style: TextStyle(
                        color: isDarkMode ? Colors.amber : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  final donateUrl = 'https://www.cubosquare.com/contact/';
                  _openUrl(donateUrl);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDarkMode ? Colors.amber : Colors.green,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.reviews_outlined,
                      color: isDarkMode ? Colors.amber : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "REVIEW US",
                      style: TextStyle(
                        color: isDarkMode ? Colors.amber : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              //   ElevatedButton(
              //     onPressed: () => _openUrl('https://www.reviewpage.com'),
              //     child: Text('Review Us'),
              //   ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
