import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/currency_text.dart';
import '../../domain/entities/insight_card.dart';
import 'insight_icon.dart';
import 'insight_localizer.dart';

class InsightCardWidget extends StatelessWidget {
  const InsightCardWidget({required this.insight, super.key});

  final InsightCard insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InsightIcon(type: insight.type),
                SizedBox(width: 12.w),
                Expanded(child: _InsightHeader(insight: insight)),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              InsightLocalizer.message(context, insight),
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightHeader extends StatelessWidget {
  const _InsightHeader({required this.insight});

  final InsightCard insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supportingStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          InsightLocalizer.title(insight),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (insight.amount != null)
          CurrencyText(amount: insight.amount!, style: supportingStyle)
        else if (insight.value != null)
          Text(InsightLocalizer.value(insight), style: supportingStyle),
      ],
    );
  }
}
