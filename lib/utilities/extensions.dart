import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:melonandmelon/utilities/packages.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');

  String toException() {
    return split(":")[1].trim();
  }

  String toDate() {
    final date = DateTime.parse(this);
    return DateFormat.yMMMMd().format(date);
  }

String formatNumber(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return number.toString();
  }
}
  String timeAgo() {
    final now = DateTime.now();
    final date = DateTime.parse(this);
    final difference = now.difference(date);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'mon' : 'mons'} ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hr' : 'hrs'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
    } else {
      return 'just now';
    }
  }

  String encrypt() {
    final splitString = this.split('');
    final firstSubstring = splitString[0];
    final lastSubstring = splitString[splitString.length - 1];
    return "$lastSubstring***$firstSubstring";
  }

  String formatAmount() {
    double amount = double.parse(this);
    String formattedAmount = amount.toStringAsFixed(2);
    final parts = formattedAmount.split('.');
    final RegExp regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    parts[0] =
        parts[0].replaceAllMapped(regex, (Match match) => '${match[1]},');
    return parts.join('.');
  }
}

extension ErrorToast on BuildContext {
  void showErrorToast({
    required String title,
    required String message,
    required BuildContext context,
  }) {
    Toastification().show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      ),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void showSuccessToast(
      {required String title,
      required String message,
      required BuildContext context}) {
    Toastification().show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: green,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: green,
          fontWeight: FontWeight.w400,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
    return;
  }

  void showInfoToast(
      {required String title,
      required String message,
      required BuildContext context}) {
    Toastification().show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 2.2 * SizeConfig.textMultiplier,
          color: green,
          fontWeight: FontWeight.w600,
        ),
      ),
      description: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 1.8 * SizeConfig.textMultiplier,
          color: const Color(0xff606873),
          fontWeight: FontWeight.w400,
        ),
      ),
      icon: const Icon(
        Icons.close,
        size: 20,
        color: Color(0xff606873),
      ),
      alignment: Alignment.bottomCenter,
      closeOnClick: true,
      autoCloseDuration: const Duration(seconds: 10),
    );
  }


  void showSuccessSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Row(
          children: [
            Text(
              message,
              style: GoogleFonts.notoSans(
                fontSize: 1.8 * SizeConfig.textMultiplier,
                color: const Color(0xff171717),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(
                this,
              ).hideCurrentSnackBar(),

              child: Icon(
                Icons.close,
                color: black,
                size: 2.5 * SizeConfig.heightMultiplier,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color(0xff777777),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showInfoSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showWarningSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 2 * SizeConfig.textMultiplier,
            color: white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.yellow.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          children: [
            Text(
              message,
              style: GoogleFonts.notoSans(
                fontSize: 1.8 * SizeConfig.textMultiplier,
                color: black
                ,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(this).hideCurrentSnackBar();
              },
              child: Icon(
                Icons.close,
                color: white,
                size: 2.5 * SizeConfig.heightMultiplier,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 230, 82, 82),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void hideToast() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  void debouncer({required Duration duration}) {
    Future.delayed(duration);
    return;
  }

  Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
