import 'package:intl/intl.dart';

/// Classe utilitaire pour le formatage des données
class FormatUtils {
  /// Formater le prix en devise
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Formater la devise avec symbole
  static String formatCurrency(double amount, {String currency = '\$'}) {
    return '$currency${amount.toStringAsFixed(2)}';
  }

  /// Formater la date
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formater la date et l'heure
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formater le temps écoulé
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Formater le nombre avec séparateurs de milliers
  static String formatNumber(int number) {
    return NumberFormat('#,##0').format(number);
  }

  /// Formater le nombre décimal
  static String formatDecimal(double number, {int decimals = 2}) {
    return number.toStringAsFixed(decimals);
  }

  /// Limiter la longueur du texte
  static String truncate(String text, {int length = 50}) {
    if (text.length <= length) {
      return text;
    }
    return '${text.substring(0, length)}...';
  }
}
