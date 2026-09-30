import '../../../../l10n/app_localizations.dart';

String localModelSizeLabel(AppLocalizations l10n, int bytes) {
  const gigabyte = 1000 * 1000 * 1000;
  const megabyte = 1000 * 1000;
  if (bytes >= gigabyte) {
    final size = (bytes / gigabyte).toStringAsFixed(1);
    return l10n.accountModelSizeGigabytes(size);
  }
  final megabytes = (bytes / megabyte).ceil();
  return l10n.accountModelSizeMegabytes('$megabytes');
}
