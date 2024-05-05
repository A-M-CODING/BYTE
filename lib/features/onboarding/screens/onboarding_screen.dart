import 'package:flutter/material.dart';
import 'package:byte_app/features/onboarding/configurations/size_config.dart';
import 'package:byte_app/features/onboarding/model/onboarding_contents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:byte_app/features/home/screens/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    _checkFirstSeen();
    super.initState();
  }

  int _currentPage = 0;
  List<Color> colors = const [
    Color(0xFFFFEDEB),
    Color(0xFFFFEDEB),
    Color(0xFFFFEDEB),
  ];

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      await prefs.setBool('seen', true);
    }
  }

  AnimatedContainer _buildDots({
    required int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure SizeConfig is initialized and screen dimensions are non-null
    SizeConfig().init(context);
    double width = SizeConfig.screenW ?? MediaQuery.of(context).size.width;
    double height = SizeConfig.screenH ?? MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: (SizeConfig.blockV ?? 5) *
                              35, // Assuming 5 as a default value if blockV is null
                        ),
                        SizedBox(
                          height: (height >= 840) ? 60 : 30,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: AppTheme.of(context).subtitle1.copyWith(
                                fontSize: (width <= 550) ? 25 : 35,
                              ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          contents[i].desc,
                          style: AppTheme.of(context).bodyText1.copyWith(
                                fontSize: (width <= 550) ? 14 : 25,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomePage())),
                            child: const Text(
                              "START",
                              style: TextStyle(color: Color(0xFFF4F4F4)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFC7562),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: (width <= 550)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 20)
                                  : EdgeInsets.symmetric(
                                      horizontal: width * 0.2, vertical: 25),
                              textStyle:
                                  AppTheme.of(context).subtitle1.copyWith(
                                        fontSize: (width <= 550) ? 13 : 17,
                                      ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(2);
                                },
                                child: const Text(
                                  "SKIP",
                                  style: TextStyle(color: Color(0xFFFC7562)),
                                ),
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle:
                                      AppTheme.of(context).subtitle1.copyWith(
                                            fontSize: (width <= 550) ? 13 : 17,
                                          ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                child: const Text(
                                  "NEXT",
                                  style: TextStyle(color: Color(0xFFF4F4F4)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFC7562),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                  textStyle:
                                      AppTheme.of(context).subtitle1.copyWith(
                                            fontSize: (width <= 550) ? 13 : 17,
                                          ),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
