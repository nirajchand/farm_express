import 'package:farm_express/screens/choose_role_screen.dart';
import 'package:farm_express/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark
        ? AppColors.getDark() as dynamic
        : AppColors.getLight() as dynamic;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(backgroundColor: colors.background, elevation: 0),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                  style: TextStyle(fontSize: 18, color: colors.info),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _data.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black45 : Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
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
                        const SizedBox(height: 12),
                        Text(
                          _data[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _data[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: colors.textSecondary,
                          ),
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
                  margin: const EdgeInsets.only(right: 6),
                  height: 10,
                  width: _pageIndex == index ? 25 : 10,
                  decoration: BoxDecoration(
                    color: _pageIndex == index
                        ? colors.primary
                        : colors.greyLight,
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
                    backgroundColor: colors.primary,
                    foregroundColor: colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
