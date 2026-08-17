import 'dart:async';
import 'package:flutter/material.dart';

import '../models/session.dart';
import '../theme.dart';
import 'countdown_text.dart';

enum SessionCardKind { current, past, next }

class _KindStyle {
  final String label;
  final IconData icon;
  final Color color;
  const _KindStyle(this.label, this.icon, this.color);
}

_KindStyle _styleFor(SessionCardKind kind) {
  switch (kind) {
    case SessionCardKind.current:
      return const _KindStyle('جارٍ الآن', Icons.bolt_rounded, AppColors.gold);
    case SessionCardKind.past:
      return const _KindStyle('انتهى قبل قليل', Icons.check_circle_rounded, AppColors.textFaint);
    case SessionCardKind.next:
      return const _KindStyle('البرنامج القادم', Icons.arrow_forward_rounded, AppColors.emerald);
  }
}

/// بطاقة تعرض تفاصيل فقرة (سابقة / حالية / قادمة) مع عداد إن لزم.
class SessionStatusCard extends StatelessWidget {
  final SessionCardKind kind;
  final Session? session;
  final DateTime campStart;

  const SessionStatusCard({
    super.key,
    required this.kind,
    required this.session,
    required this.campStart,
  });

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(kind);
    final isCurrent = kind == SessionCardKind.current;
    final isPast = kind == SessionCardKind.past;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isPast ? 18 : 24),
        color: isPast ? AppColors.surface.withOpacity(0.6) : AppColors.surface,
        border: Border.all(
          color: isCurrent ? style.color.withOpacity(0.55) : AppColors.outline,
          width: isCurrent ? 1.4 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: style.color.withOpacity(0.16),
                  blurRadius: 28,
                  spreadRadius: -6,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(isPast ? 14 : 20),
      child: session == null
          ? _empty(context, style)
          : (isPast ? _pastContent(context, session!, style) : _content(context, session!, style)),
    );
  }

  Widget _pastContent(BuildContext context, Session s, _KindStyle style) {
    final theme = Theme.of(context);
    final start = s.startDateTime(campStart);
    final end = s.endDateTime(campStart);
    return Row(
      children: [
        Icon(style.icon, color: style.color, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.title,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text('انتهى ${formatClock(end)}', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Text(
          '${formatClock(start)} – ${formatClock(end)}',
          style: AppTheme.mono(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textFaint),
        ),
      ],
    );
  }

  Widget _pill(BuildContext context, _KindStyle style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.color),
          const SizedBox(width: 6),
          Text(style.label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: style.color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context, _KindStyle style) {
    return Row(
      children: [
        _pill(context, style),
        const Spacer(),
        Text('لا يوجد', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _content(BuildContext context, Session s, _KindStyle style) {
    final theme = Theme.of(context);
    final start = s.startDateTime(campStart);
    final end = s.endDateTime(campStart);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _pill(context, style),
            const Spacer(),
            _timePair(context, start, end),
          ],
        ),
        const SizedBox(height: 14),
        Text(s.title, style: theme.textTheme.headlineSmall),
        if (s.venue.isNotEmpty && s.venue != '-' || s.responsible.isNotEmpty && s.responsible != '-') ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (s.venue.isNotEmpty && s.venue != '-')
                _metaChip(context, Icons.place_rounded, s.venue),
              if (s.responsible.isNotEmpty && s.responsible != '-')
                _metaChip(context, Icons.person_rounded, s.responsible),
            ],
          ),
        ],
        if (kind == SessionCardKind.current) ...[
          const SizedBox(height: 20),
          _RadialCountdown(start: start, end: end, color: style.color),
        ],
        if (kind == SessionCardKind.next) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.hourglass_bottom_rounded, size: 16, color: style.color),
                const SizedBox(width: 8),
                Text('يبدأ خلال', style: theme.textTheme.labelLarge),
                const Spacer(),
                CountdownText(
                  target: start,
                  style: AppTheme.mono(fontSize: 20, fontWeight: FontWeight.w700, color: style.color),
                ),
              ],
            ),
          ),
        ],
        if (s.notes.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(s.notes, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }

  Widget _timePair(BuildContext context, DateTime start, DateTime end) {
    return Text(
      '${formatClock(start)} – ${formatClock(end)}',
      style: AppTheme.mono(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted),
    );
  }

  Widget _metaChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textFaint),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// حلقة تقدّم دائرية حول عداد تنازلي، مع تحديث حي كل ثانية.
class _RadialCountdown extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final Color color;
  const _RadialCountdown({required this.start, required this.end, required this.color});

  @override
  State<_RadialCountdown> createState() => _RadialCountdownState();
}

class _RadialCountdownState extends State<_RadialCountdown> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.end.difference(widget.start).inSeconds;
    final elapsed = DateTime.now().difference(widget.start).inSeconds;
    final fraction = total <= 0 ? 0.0 : (elapsed / total).clamp(0.0, 1.0);
    final remaining = widget.end.difference(DateTime.now());

    return Row(
      children: [
        SizedBox(
          width: 84,
          height: 84,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  valueColor: const AlwaysStoppedAnimation(AppColors.surfaceHighlight),
                ),
              ),
              SizedBox(
                width: 84,
                height: 84,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation(widget.color),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Icon(Icons.bolt_rounded, color: widget.color, size: 22),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الوقت المتبقي', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              CountdownText(
                target: widget.end,
                style: AppTheme.mono(fontSize: 30, fontWeight: FontWeight.w700, color: widget.color),
              ),
              const SizedBox(height: 2),
              Text(remaining.isNegative ? 'انتهى للتو' : '${(fraction * 100).round()}٪ مكتمل',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

/// عنصر مبسّط لعرض فقرة داخل قائمة زمنية (Timeline) — شاشة "عرض الكل" ولوحة التحكم.
class SessionListTile extends StatelessWidget {
  final Session session;
  final DateTime campStart;
  final bool highlight;
  final bool isLast;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SessionListTile({
    super.key,
    required this.session,
    required this.campStart,
    this.highlight = false,
    this.isLast = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final start = session.startDateTime(campStart);
    final end = session.endDateTime(campStart);
    final dotColor = highlight ? AppColors.gold : AppColors.outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 58,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    formatClock(start),
                    textAlign: TextAlign.center,
                    style: AppTheme.mono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: highlight ? AppColors.gold : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: highlight ? AppColors.gold : AppColors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: dotColor, width: 2),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.outline),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: highlight ? AppColors.goldSoft.withOpacity(0.35) : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: highlight ? AppColors.gold.withOpacity(0.5) : AppColors.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(session.title, style: Theme.of(context).textTheme.titleMedium),
                            if (session.venue.isNotEmpty && session.venue != '-' ||
                                session.responsible.isNotEmpty && session.responsible != '-') ...[
                              const SizedBox(height: 4),
                              Text(
                                [
                                  if (session.venue.isNotEmpty && session.venue != '-') session.venue,
                                  if (session.responsible.isNotEmpty && session.responsible != '-')
                                    session.responsible,
                                ].join(' · '),
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
