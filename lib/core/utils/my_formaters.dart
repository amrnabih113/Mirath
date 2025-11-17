class MyFormaters {
  MyFormaters._();

  /// Format a [DateTime] as `yyyy-MM-dd`.
  static String formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Format a [DateTime] time portion as `HH:mm` in 24-hour clock.
  static String formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  /// Format a [DateTime] as `yyyy-MM-dd HH:mm:ss`.
  static String formatDateTime(DateTime dt) {
    final sec = dt.second.toString().padLeft(2, '0');
    return '${formatDate(dt)} ${formatTime(dt)}:$sec';
  }

  /// Try to parse an ISO-8601 string into [DateTime]. Returns `null` on failure.
  static DateTime? tryParseIso(String input) {
    try {
      return DateTime.parse(input);
    } catch (_) {
      return null;
    }
  }

  /// Human friendly relative time (e.g. "5 minutes ago", "in 2 days").
  ///
  /// If [reference] is not provided, [DateTime.now] is used.
  static String relativeTime(DateTime date, {DateTime? reference}) {
    final now = reference ?? DateTime.now();
    final diff = now.difference(date);
    final past = !diff.isNegative;
    final d = diff.abs();

    if (d.inSeconds < 60) return past ? 'just now' : 'in a few seconds';
    if (d.inMinutes < 60) {
      final v = d.inMinutes;
      return past
          ? '$v minute${v == 1 ? '' : 's'} ago'
          : 'in $v minute${v == 1 ? '' : 's'}';
    }
    if (d.inHours < 24) {
      final v = d.inHours;
      return past
          ? '$v hour${v == 1 ? '' : 's'} ago'
          : 'in $v hour${v == 1 ? '' : 's'}';
    }
    if (d.inDays < 30) {
      final v = d.inDays;
      return past
          ? '$v day${v == 1 ? '' : 's'} ago'
          : 'in $v day${v == 1 ? '' : 's'}';
    }
    final months = (d.inDays / 30).floor();
    if (months < 12) {
      return past
          ? '$months month${months == 1 ? '' : 's'} ago'
          : 'in $months month${months == 1 ? '' : 's'}';
    }
    final years = (d.inDays / 365).floor();
    return past
        ? '$years year${years == 1 ? '' : 's'} ago'
        : 'in $years year${years == 1 ? '' : 's'}';
  }

  /// Convert a [DateTime] to UTC (preserves the absolute moment in time).
  static DateTime toUtc(DateTime dt) => dt.toUtc();

  /// Convert a [DateTime] to local time (preserves the absolute moment in time).
  static DateTime toLocal(DateTime dt) => dt.toLocal();

  /// Format a [DateTime] as an ISO-8601 UTC string: `yyyy-MM-ddTHH:mm:ssZ`.
  static String formatIsoUtc(DateTime dt) {
    final u = dt.toUtc();
    final y = u.year.toString().padLeft(4, '0');
    final m = u.month.toString().padLeft(2, '0');
    final d = u.day.toString().padLeft(2, '0');
    final hh = u.hour.toString().padLeft(2, '0');
    final mm = u.minute.toString().padLeft(2, '0');
    final ss = u.second.toString().padLeft(2, '0');
    return '$y-$m-${d}T$hh:$mm:${ss}Z';
  }

  /// Try to parse an ISO-8601 string and return the instant in UTC, or `null`.
  static DateTime? tryParseIsoToUtc(String input) {
    final parsed = tryParseIso(input);
    return parsed?.toUtc();
  }

  /// Format the date/time together with the local offset, e.g. `2025-10-12 14:05 +02:00`.
  static String formatWithOffset(DateTime dt) {
    final off = dt.timeZoneOffset;
    final sign = off.isNegative ? '-' : '+';
    final abs = off.abs();
    final oh = abs.inHours.toString().padLeft(2, '0');
    final om = (abs.inMinutes % 60).toString().padLeft(2, '0');
    return '${formatDate(dt)} ${formatTime(dt)} $sign$oh:$om';
  }
}
