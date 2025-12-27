import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Jar',
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  // Simple pages content
  final List<Widget> _pages = [
    Center(child: Text("Welcome to Mood Jar", style: TextStyle(fontSize: 24))),
    Center(child: Text("Add your daily moods easily", style: TextStyle(fontSize: 24))),
    Center(child: Text("Track your mood trends", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: EdgeInsets.all(4),
                width: currentPage == index ? 12 : 8,
                height: currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.blue : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Next or Get Started button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                if (currentPage < _pages.length - 1) {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Last page → navigate to dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardScreen()),
                  );
                }
              },
              child: Text(currentPage < _pages.length - 1 ? "Next" : "Get Started"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mood Jar Dashboard")),
      body: Center(child: Text("Dashboard", style: TextStyle(fontSize: 24))),
    );
  }
}
