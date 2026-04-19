#!/usr/bin/env python3
"""Fix Wave 4 stragglers: Text('...', style:...) and standalone Text widgets with literal interpolations."""
import os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"

FIXES = {
    f'{ROOT}/lib/features/industry_bakery/widgets/cake_order_card.dart': [
        ("Text('Delivery: ${order.deliveryDate}', style: AppTypography.bodySmall)",
         "Text(l10n.bakeryDeliveryDateWithValue(order.deliveryDate.toString()), style: AppTypography.bodySmall)"),
    ],
    f'{ROOT}/lib/features/industry_bakery/widgets/recipe_card.dart': [
        ("Text('Prep: ${recipe.prepTimeMinutes}min', style: AppTypography.bodySmall)",
         "Text(l10n.bakeryPrepTimeMin(recipe.prepTimeMinutes.toString()), style: AppTypography.bodySmall)"),
        ("Text('Bake: ${recipe.bakeTimeMinutes}min', style: AppTypography.bodySmall)",
         "Text(l10n.bakeryBakeTimeMin(recipe.bakeTimeMinutes.toString()), style: AppTypography.bodySmall)"),
    ],
    f'{ROOT}/lib/features/industry_electronics/widgets/repair_job_card.dart': [
        ("if (job.imei != null) Text('IMEI: ${job.imei}', style: AppTypography.caption)",
         "if (job.imei != null) Text(l10n.electronicsImeiWithValue(job.imei!), style: AppTypography.caption)"),
        ("Text('Est: ${job.estimatedCost!.toStringAsFixed(2)} \\u0081', style: AppTypography.bodySmall)",
         "Text(l10n.electronicsEstCostWithValue(job.estimatedCost!.toStringAsFixed(2)), style: AppTypography.bodySmall)"),
    ],
    f'{ROOT}/lib/features/industry_electronics/widgets/trade_in_card.dart': [
        ("Text('IMEI: ${record.imei}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary))",
         "Text(l10n.electronicsImeiWithValue(record.imei ?? ''), style: AppTypography.caption.copyWith(color: AppColors.textSecondary))"),
    ],
    f'{ROOT}/lib/features/industry_florist/widgets/arrangement_card.dart': [
        ("Text('${arrangement.itemsJson.length} flower types', style: AppTypography.bodySmall)",
         "Text(l10n.floristFlowerTypesCount(arrangement.itemsJson.length.toString()), style: AppTypography.bodySmall)"),
    ],
    f'{ROOT}/lib/features/industry_florist/widgets/freshness_log_card.dart': [
        ("Text('Product: ${log.productId}', style: AppTypography.titleSmall)",
         "Text(l10n.floristProductWithId(log.productId), style: AppTypography.titleSmall)"),
        ("Text('Qty: ${log.quantity} · Received: ${log.receivedDate}', style: AppTypography.caption)",
         "Text(l10n.floristQtyReceivedOn(log.quantity.toString(), log.receivedDate.toString()), style: AppTypography.caption)"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/widgets/metal_rate_card.dart': [
        ("Text('Effective: ${rate.effectiveDate}', style: AppTypography.caption)",
         "Text(l10n.jewelryEffectiveWithValue(rate.effectiveDate.toString()), style: AppTypography.caption)"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/pages/product_detail_form_page.dart': [
        ("Text('Stone Details', style: Theme.of(context).textTheme.titleMedium)",
         "Text(l10n.jewelryStoneDetails, style: Theme.of(context).textTheme.titleMedium)"),
    ],
    f'{ROOT}/lib/features/industry_pharmacy/pages/prescription_form_page.dart': [
        ("Text('Doctor Information', style: Theme.of(context).textTheme.titleMedium)",
         "Text(l10n.pharmacyDoctorInfo, style: Theme.of(context).textTheme.titleMedium)"),
        ("Text('Insurance', style: Theme.of(context).textTheme.titleMedium)",
         "Text(l10n.pharmacyInsurance, style: Theme.of(context).textTheme.titleMedium)"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/kitchen_ticket_card.dart': [
        ("Text('#${ticket.ticketNumber}', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600))",
         "Text(l10n.restaurantTicketNumberSign(ticket.ticketNumber.toString()), style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600))"),
        ("Text('Station: ${ticket.station}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))",
         "Text(l10n.restaurantStation(ticket.station), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))"),
        ("Text('Course ${ticket.courseNumber}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))",
         "Text(l10n.restaurantCourse(ticket.courseNumber.toString()), style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary))"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/open_tab_card.dart': [
        ("Text('Close Tab', style: AppTypography.labelSmall.copyWith(color: AppColors.error))",
         "Text(l10n.restaurantCloseTab, style: AppTypography.labelSmall.copyWith(color: AppColors.error))"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/reservation_card.dart': [
        ("Text('${reservation.durationMinutes} min', style: AppTypography.caption.copyWith(color: AppColors.textSecondary))",
         "Text(l10n.restaurantDurationMin(reservation.durationMinutes.toString()), style: AppTypography.caption.copyWith(color: AppColors.textSecondary))"),
    ],
}


def ensure_l10n(content):
    if 'app_localizations.dart' not in content:
        lines = content.split('\n')
        last_import = -1
        for i, line in enumerate(lines):
            if line.startswith('import '):
                last_import = i
        if last_import >= 0:
            lines.insert(last_import + 1, L10N_IMPORT)
        content = '\n'.join(lines)
    # Add l10n getter inside build() if missing
    if 'l10n.' in content and not re.search(r'(final|get)\s+l10n\s*(=|=>)', content):
        pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context\s*\)\s*\{\s*\n)')
        content = pattern.sub(r'\1    final l10n = AppLocalizations.of(context)!;\n', content, count=1)
    return content


total = 0
for path, subs in FIXES.items():
    with open(path) as f:
        content = f.read()
    count = 0
    for old, new in subs:
        if old in content:
            content = content.replace(old, new)
            count += 1
        else:
            print(f'  ⚠ NOT FOUND in {os.path.basename(path)}: {old[:60]}...')
    if count:
        content = ensure_l10n(content)
        with open(path, 'w') as f:
            f.write(content)
        print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
        total += count
print(f'\n  Total: {total}')
