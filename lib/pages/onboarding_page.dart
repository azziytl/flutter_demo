import 'package:flutter/material.dart';
import 'package:demoapp/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key, required this.isNewUser}) : super(key: key);

  final bool isNewUser;

  @override
  State<OnboardingPage> createState() => _OnboardingPage();
}

class _OnboardingPage extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required Widget content,
  }) =>
      Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.teal.shade700,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: content,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 350,
              child: Image.asset(
                urlImage,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                color: Colors.green.shade100,
                urlImage: 'assets/page1.png',
                title: 'WELCOME!',
                content: Text(
                  'Welcome to the Attendance Record Application',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              buildPage(
                color: Colors.green.shade100,
                urlImage: 'assets/page2.png',
                title: 'PURPOSE',
                content: Text(
                  'This application serves the users to view the attendance record list along with more useful features',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              buildPage(
                color: Colors.green.shade100,
                urlImage: 'assets/page3.png',
                title: 'GUIDE',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureRow(Icons.add, 'Add button',
                        'to add new attendance record to the list'),
                    _buildFeatureRow(Icons.access_time, 'Time format toggle',
                        'change time format displayed by clicking on it'),
                    _buildFeatureRow(Icons.search, 'Search field',
                        'for you to filter the list by key-in any keyword into it'),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  backgroundColor: Colors.teal.shade700,
                  minimumSize: const Size.fromHeight(90),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () async {
                  // Update SharedPreferences to mark onboarding as completed
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isNewUser', false);

                  // Navigate directly to home page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'List of Attendance',
                      ),
                    ),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('SKIP'),
                      onPressed: () => controller.jumpToPage(2),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: WormEffect(
                          spacing: 16,
                          dotColor: Colors.black26,
                          activeDotColor: Colors.teal.shade700,
                        ),
                        onDotClicked: (index) => controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                      ),
                    ),
                    TextButton(
                      child: const Text('NEXT'),
                      onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal.shade700),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
