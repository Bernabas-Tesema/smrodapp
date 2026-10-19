import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../authentication/presentation/viewmodels/auth_viewmodel.dart';
import '../../../security/presentation/widgets/security_status_card.dart';
import '../../../../shared/widgets/asset_glyph.dart';
import '../viewmodels/vehicle_viewmodel.dart';

/// Vehicle dashboard screen.
class VehicleDashboardScreen extends ConsumerWidget {
  const VehicleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(vehicleViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;
    final vehicle = state.vehicle;

    if (vehicle == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: AppLoader(message: 'Loading vehicle status...'),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            _WelcomeCard(
              name: user?.displayName ?? 'Owner',
              onAlerts: () => context.go('/alerts'),
              onAccount: () => _account(context),
            ),
            const SizedBox(height: 14),
            SecurityStatusCard(vehicle: vehicle),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: Text('Quick actions', style: AppTextStyles.title)),
                TextButton(onPressed: () => context.go('/security'), child: const Text('View all')),
              ],
            ),
            const _QuickActions(),
            const SizedBox(height: 16),
            const _SosCard(),
          ],
        ),
      ),
    );
  }

  void _account(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final auth = ref.watch(authViewModelProvider);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.user?.displayName ?? '', style: AppTextStyles.title),
                  Text(auth.user?.email ?? '', style: AppTextStyles.caption),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const AssetGlyph('assets/images/finger print.jpg', size: 36),
                    title: const Text('Biometric app lock'),
                    subtitle: Text(auth.error ?? 'Ask for biometrics the next time the app opens.'),
                    value: auth.biometricEnabled,
                    activeThumbColor: AppColors.green,
                    onChanged: (value) => ref.read(authViewModelProvider.notifier).setBiometric(value),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(authViewModelProvider.notifier).logout();
                    },
                    child: const Text('Log out'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.name, required this.onAlerts, required this.onAccount});

  final String name;
  final VoidCallback onAlerts;
  final VoidCallback onAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(colors: [AppColors.red, AppColors.green]),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onAccount,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Image.asset('assets/images/smrod_logo.png'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          IconButton(
            onPressed: onAlerts,
            icon: const AssetGlyph('assets/images/notifcation.jpg', size: 32),
          ),
        ],
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.red,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: () => context.push('/emergency'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Help?',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap the button to alert your contacts',
                      style: TextStyle(color: Colors.white, height: 1.3),
                    ),
                  ],
                ),
              ),
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                alignment: Alignment.center,
                child: const Text('SOS', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _CircleAction(icon: Icons.lock_outline, label: 'Immobilize', color: AppColors.green, onTap: () => context.push('/control')),
        _CircleAction(icon: Icons.place_outlined, label: 'Live map', color: AppColors.red, onTap: () => context.go('/track')),
        _CircleAction(icon: Icons.shield_outlined, label: 'Security', color: AppColors.red, onTap: () => context.go('/security')),
        _CircleAction(icon: Icons.radar, label: 'Geofence', color: AppColors.greenDark, onTap: () => context.push('/geofence')),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

