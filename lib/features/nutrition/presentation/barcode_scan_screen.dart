import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/widgets/lift_button.dart';
import '../../../l10n/app_localizations.dart';
import '../services/food_search_result.dart';
import '../services/open_food_facts_service.dart';
import 'confirm_food_sheet.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  final _controller = MobileScannerController();
  final _offService = OpenFoodFactsService();
  bool _busy = false;
  bool _notFound = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy || capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() {
      _busy = true;
      _notFound = false;
    });
    await _controller.stop();

    try {
      final result = await _offService.lookupBarcode(code);
      if (!mounted) return;

      if (result == null) {
        setState(() {
          _busy = false;
          _notFound = true;
        });
        await _controller.start();
        return;
      }

      final logged = await _openConfirm(result);
      if (!mounted) return;
      if (logged == true) {
        Navigator.of(context).pop();
        return;
      }
      setState(() => _busy = false);
      await _controller.start();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorMessage('$e'))));
      setState(() => _busy = false);
      await _controller.start();
    }
  }

  Future<bool?> _openConfirm(FoodSearchResult result) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ConfirmFoodSheet(searchResult: result),
    );
  }

  Future<void> _enterManually() async {
    final logged = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ConfirmFoodSheet(),
    );
    if (logged == true && mounted) Navigator.of(context).pop();
  }

  String _errorMessage(AppLocalizations l10n, MobileScannerException error) {
    return switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => l10n.nutritionCameraPermissionDenied,
      MobileScannerErrorCode.unsupported => l10n.nutritionScannerUnsupported,
      _ => l10n.errorMessage('${error.errorCode}'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionScanBarcodeOption)),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage(l10n, error),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: _enterManually,
                      child: Text(l10n.nutritionManualOption),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_busy) const Center(child: CircularProgressIndicator()),
          if (_notFound)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: c.surface,
                padding: EdgeInsets.only(
                  left: AppSpacing.xxl,
                  right: AppSpacing.xxl,
                  top: AppSpacing.xl,
                  bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.nutritionBarcodeNotFound,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    LiftPrimaryButton(label: l10n.nutritionManualOption, onPressed: _enterManually),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
