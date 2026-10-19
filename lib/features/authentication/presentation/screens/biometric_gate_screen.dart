import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/brand_backdrop.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Fingerprint access screen. The layout is in-app and does not depend on a
/// device sensor being present.
class BiometricGateScreen extends ConsumerWidget {
  const BiometricGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BrandBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/welcome');
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.fingerprint,
                    size: 120,
                    color: AppColors.red,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Fingerprint access',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Confirm it is you before ${AppConstants.appName} opens.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.muted,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _continue(context, ref),
                      child: const Text('Continue'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Use password login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authViewModelProvider);
    if (auth.isAuthenticated) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/dashboard');
      }
      return;
    }
    final unlocked = await ref
        .read(authViewModelProvider.notifier)
        .continuePastBiometric();
    if (!context.mounted) return;
    context.go(unlocked ? '/dashboard' : '/login');
  }
}
