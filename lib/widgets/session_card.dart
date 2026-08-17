import 'package:flutter/material.dart';

import '../models/session.dart';
import 'countdown_text.dart';

enum SessionCardKind { current, past, next }

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
    final scheme = Theme.of(context).colorScheme;
    final (label, icon, color) = switch (kind) {
      SessionCardKind.current => ('البرنامج الحالي', Icons.play_circle_fill, scheme.primary),
      SessionCardKind.past => ('البرنامج السابق', Icons.check_circle, scheme.outline),
      SessionCardKind.next => ('البرنامج القادم', Icons.upcoming, scheme.tertiary),
    };

    return Card(
      elevation: kind == SessionCardKind.current ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: kind == SessionCardKind.current
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: session == null
            ? _empty(context, label, icon, color)
            : _content(context, session!, label, icon, color),
      ),
    );
  }

  Widget _empty(BuildContext context, String label, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Text('لا يوجد', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _content(
    BuildContext context,
    Session s,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final start = s.startDateTime(campStart);
    final end = s.endDateTime(campStart);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelLarge?.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Text(s.title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 4),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            if (s.venue.isNotEmpty && s.venue != '-')
              _chip(context, Icons.place_outlined, s.venue),
            if (s.responsible.isNotEmpty && s.responsible != '-')
              _chip(context, Icons.person_outline, s.responsible),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _timeInfo(context, 'بدأ الساعة', formatClock(start)),
            ),
            Expanded(
              child: _timeInfo(context, 'ينتهي الساعة', formatClock(end)),
            ),
          ],
        ),
        if (kind == SessionCardKind.current) ...[
          const SizedBox(height: 12),
          _progressBar(context, start, end),
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Text('المتبقي', style: theme.textTheme.labelMedium),
                CountdownText(
                  target: end,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (kind == SessionCardKind.next) ...[
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text('يبدأ خلال', style: theme.textTheme.labelMedium),
                CountdownText(
                  target: start,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (s.notes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(s.notes, style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }

  Widget _progressBar(BuildContext context, DateTime start, DateTime end) {
    final total = end.difference(start).inSeconds;
    final elapsed = DateTime.now().difference(start).inSeconds;
    final fraction = total <= 0 ? 0.0 : (elapsed / total).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(value: fraction, minHeight: 8),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _timeInfo(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}

/// عنصر مبسّط لعرض فقرة داخل قائمة (شاشة "عرض الكل" ولوحة التحكم).
class SessionListTile extends StatelessWidget {
  final Session session;
  final DateTime campStart;
  final bool highlight;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SessionListTile({
    super.key,
    required this.session,
    required this.campStart,
    this.highlight = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final start = session.startDateTime(campStart);
    final end = session.endDateTime(campStart);
    return Card(
      color: highlight ? scheme.primaryContainer : null,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formatClock(start),
                  style: Theme.of(context).textTheme.labelLarge,
                  textDirection: TextDirection.ltr),
              Text(formatClock(end),
                  style: Theme.of(context).textTheme.labelSmall,
                  textDirection: TextDirection.ltr),
            ],
          ),
        ),
        title: Text(session.title),
        subtitle: Text([
          if (session.venue.isNotEmpty && session.venue != '-') session.venue,
          if (session.responsible.isNotEmpty && session.responsible != '-')
            session.responsible,
        ].join(' • ')),
        trailing: trailing,
      ),
    );
  }
}
