import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../design/tokens/app_colors.dart';
import '../../../design/tokens/app_spacing.dart';
import '../../../design/tokens/app_typography.dart';

class TrainingCalendar extends StatefulWidget {
  final Set<DateTime> workoutDays; // day-truncated (y, m, d), local time
  final void Function(DateTime day) onDayTap;

  const TrainingCalendar({super.key, required this.workoutDays, required this.onDayTap});

  @override
  State<TrainingCalendar> createState() => _TrainingCalendarState();
}

class _TrainingCalendarState extends State<TrainingCalendar> {
  late DateTime _displayedMonth;

  // 2024-01-01 was a Monday — used only as an anchor to derive locale-correct
  // abbreviated weekday names Mon..Sun, not a real displayed date.
  static final _mondayAnchor = DateTime(2024, 1, 1);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  void _goToPreviousMonth() {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1));
  }

  void _goToNextMonth() {
    setState(() => _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1));
  }

  bool _hasWorkout(DateTime day) => widget.workoutDays.contains(day);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final today = DateTime.now();
    final firstOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday - 1; // Monday-first grid

    final weekdayLabels = List.generate(
      7,
      (i) => DateFormat.E(locale).format(_mondayAnchor.add(Duration(days: i))),
    );

    final cells = <Widget>[
      for (var i = 0; i < leadingBlanks; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++) _buildDayCell(context, c, today, d),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              color: c.textSecondary,
              onPressed: _goToPreviousMonth,
            ),
            Text(
              '${DateFormat.MMMM(locale).format(_displayedMonth)} ${_displayedMonth.year}',
              style: theme.textTheme.titleSmall,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              color: c.textSecondary,
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        Row(
          children: weekdayLabels
              .map((label) => Expanded(
                    child: Center(
                      child: Text(
                        label.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(color: c.textSecondary),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xs),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: cells,
        ),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, LiftColors c, DateTime today, int d) {
    final day = DateTime(_displayedMonth.year, _displayedMonth.month, d);
    final hasWorkout = _hasWorkout(day);
    final isToday = day.year == today.year && day.month == today.month && day.day == today.day;

    return InkWell(
      onTap: hasWorkout ? () => widget.onDayTap(day) : null,
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasWorkout ? c.violet : null,
            border: isToday
                ? Border.all(color: hasWorkout ? c.violetLight : c.violet, width: 1.5)
                : null,
          ),
          child: Text(
            '$d',
            style: AppTypography.numeral(
              size: 13,
              color: hasWorkout ? Colors.white : c.textSecondary,
              weight: hasWorkout ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
