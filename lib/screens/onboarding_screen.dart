import 'package:farm_express/core/constants/colors.dart';
import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<Map<String, String>> _data = [
    {
      "title": "Fresh from farms",
      "desc":
          "Get fresh vegetables, fruits and dairy products directly from farms.",
      "image": "assets/images/vegetable.jpg",
    },
    {
      "title": "Fast and Safe Delivery",
      "desc":
          "We deliver fresh farm products to your doorstep fast and quickly.",
      "image": "assets/images/delivery.webp",
    },
    {
      "title": "Healthy Living",
      "desc": "Eat healthy, support farmers and live a better life.",
      "image": "assets/images/healthy.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseRoleScreen(),
                    ),
                  );
                },
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _data.length,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              _data[index]["image"]!,
                              height: size.height * 0.50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Text(
                          _data[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        Text(
                          _data[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: 6),
                  height: 10,
                  width: _pageIndex == index ? 25 : 10,
                  decoration: BoxDecoration(
                    color: _pageIndex == index ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                  ),
                  onPressed: () {
                    if (_pageIndex == _data.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => ChooseRoleScreen()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(
                    _pageIndex == _data.length - 1 ? "Get Started" : "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
