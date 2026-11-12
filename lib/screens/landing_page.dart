import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:khdle/widgets/assets.dart';
import 'package:khdle/widgets/data_loader.dart';
import 'package:khdle/widgets/custom/menu_option_button.dart';

import 'character_page.dart';
import 'keyblade_page.dart';

import 'package:url_launcher/url_launcher.dart';

const double _wideBreakpoint = 1200;
const double _minWideHeight = 600;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required this.buttonOptions});

  final List<String> buttonOptions;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _hovered = false;
  bool _precached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_precached) return;

    _precached = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) precacheImage(gameBg, context);
    });
  }

  Future<void> _openPage(String value) async {
    await dataReady;

    if (!mounted) return;

    final Widget screen = switch (value) {
      'Character' => GuessCharacterPage(),
      'Keyblade' => GuessKeybladePage(),
      _ => throw ArgumentError('Unknown option: $value'),
    };

    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => screen),
    );
  }

  void _nameOnHover(bool hovering) {
    setState(() => _hovered = hovering);
  }

  double _fluid(double width, double min, double max) {
    return (max * width / 1440).clamp(min, max).toDouble();
  }

  Widget _buildAuthor(double width) {
    final double side = _fluid(width, 20, 32);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: side),
          child: Text(
            "DEVELOPED BY",
            style: TextStyle(
              color: AppColours.grey,
              fontFamily: "ScienceGothic",
              fontSize: _fluid(width, 16, 24),
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              height: 1.2,
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: width > _wideBreakpoint ? 0.2 : 0.4,
          child: Container(
            height: 2.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColours.grey, AppColours.opaqueGrey],
              ),
            ),
          ),
        ),
        AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: side),
            child: InkWell(
              onHover: _nameOnHover,
              hoverColor: Colors.transparent,
              onTap: () => launchUrl(Uri.parse("https://www.ciarabarry.ie")),
              child: Text(
                "ZEKROFIRE",
                style: TextStyle(
                  color: AppColours.grey,
                  fontFamily: "ScienceGothic",
                  fontSize: _fluid(width, 22, 32),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(double width) {
    return Column(
      spacing: _fluid(width, 16, 32),
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final value in widget.buttonOptions)
          MenuOptionButton(onPressed: () => _openPage(value), text: value),
      ],
    );
  }

  Widget _buildDisclaimer(double width) {
    final double side = _fluid(width, 20, 32);

    return Padding(
      padding: EdgeInsets.fromLTRB(side, 0, side, 16.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Developer character art by ',
              style: TextStyle(
                color: AppColours.grey,
                fontFamily: "ScienceGothic",
                fontSize: _fluid(width, 10, 12),
              ),
            ),
            TextSpan(
              text: 'miscfi',
              style: TextStyle(
                color: AppColours.grey,
                fontFamily: "ScienceGothic",
                fontSize: _fluid(width, 10, 12),
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(Uri.parse("https://www.instagram.com/miscfi"));
                },
            ),
            TextSpan(
              text: '.\nZekrofire is not affiliated with Disney or Square Enix and does not own or claim any rights to any trademark belonging to either party.',
              style: TextStyle(
                color: AppColours.grey,
                fontFamily: "ScienceGothic",
                fontSize: _fluid(width, 10, 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWide(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final double height = math.max(constraints.maxHeight, _minWideHeight);

    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Semantics(
                  label: "Art of the website developer in the style of Kingdom Hearts.",
                  child: Image.asset(
                    'assets/images/author.png',
                    height: height,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: _fluid(width, 32, 128),
                        right: 4.0,
                      ),
                      child: Semantics(
                        label: "Custom logo in the style of Kingdom Hearts, that reads: Kingdom Hearts Guesser.",
                        child: Image.asset(
                          'assets/images/main-menu-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildAuthor(width),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: _fluid(width, 32, 64)),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildButtons(width),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildDisclaimer(width),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStacked(BoxConstraints constraints) {
    final double width = constraints.maxWidth;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          spacing: 32.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 64.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _wideBreakpoint),
                child: Semantics(
                  label: "Custom logo in the style of Kingdom Hearts, that reads: Kingdom Hearts Guesser.",
                  child: Image.asset(
                    'assets/images/main-menu-logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Align(alignment: Alignment.centerLeft, child: _buildAuthor(width)),
            _buildButtons(width),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildDisclaimer(width),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= _wideBreakpoint
            ? _buildWide(constraints)
            : _buildStacked(constraints);
      },
    );
  }
}
