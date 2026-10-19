import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/brand_backdrop.dart';

/// Three-step introduction. Skip or Get Started opens biometric access first.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _IntroPage(
      kicker: 'Edge Computing',
      title: 'Local Intelligence',
      body:
          'Process vehicle data close to the device for fast responses and essential operation when connectivity is interrupted.',
      art: _Art.shield,
    ),
    _IntroPage(
      kicker: 'Cloud Computing',
      title: 'Central Intelligence',
      body:
          'Coordinate secure storage, advanced analytics, device management, and scalable AI services from the cloud.',
      art: _Art.map,
    ),
    _IntroPage(
      kicker: 'Application Layer',
      title: 'User Intelligence',
      body:
          'Turn live data into intuitive alerts, reports, analytics, and remote management through VSCU-100.',
      art: _Art.safety,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _pages.length - 1) {
      context.go('/biometric');
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final last = _index == _pages.length - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BrandBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (value) => setState(() => _index = value),
                      itemBuilder: (context, index) => _pages[index],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? AppColors.red
                                : const Color(0xFFD9D3D1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        last ? 'Get Started' : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Art { shield, map, safety }

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.kicker,
    required this.title,
    required this.body,
    required this.art,
  });

  final String kicker;
  final String title;
  final String body;
  final _Art art;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.contain,
            child: _Illustration(art: art),
          ),
        ),
        const Text(
          AppConstants.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.greenDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          kicker,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: AppColors.red,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.art});

  final _Art art;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          switch (art) {
            _Art.shield => const _ShieldArt(),
            _Art.map => const _MapArt(),
            _Art.safety => const _SafetyArt(),
          },
          const Positioned(top: 48, right: 18, child: _ProtectedChip()),
        ],
      ),
    );
  }
}

class _ProtectedChip extends StatelessWidget {
  const _ProtectedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.green),
          SizedBox(width: 6),
          Text(
            'Protected',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ShieldArt extends StatelessWidget {
  const _ShieldArt();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_user, size: 92, color: AppColors.red),
        Icon(Icons.directions_car_filled, size: 54, color: AppColors.greenDark),
      ],
    );
  }
}

class _MapArt extends StatelessWidget {
  const _MapArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.ink, width: 3),
      ),
      child: const Column(
        children: [
          SizedBox(height: 8),
          Text(
            'Map',
            style: TextStyle(
              color: AppColors.greenDark,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          Expanded(child: Icon(Icons.place, color: AppColors.red, size: 42)),
          Icon(Icons.travel_explore, color: AppColors.green, size: 36),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SafetyArt extends StatelessWidget {
  const _SafetyArt();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_pin_circle, size: 72, color: AppColors.red),
        SizedBox(width: 8),
        Icon(Icons.directions_car, size: 84, color: AppColors.green),
      ],
    );
  }
}
