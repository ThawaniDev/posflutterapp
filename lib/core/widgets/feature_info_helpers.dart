import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/feature_info_dialog.dart';

/// Centralized feature info definitions for all major feature pages.
///
/// Each method shows a [showFeatureInfoDialog] with localized content
/// describing the feature and step-by-step CRUD guides.

// ─────────────────────────────────────────────────────────────
// CATALOG
// ─────────────────────────────────────────────────────────────

void showProductListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoProductsTitle,
    description: l10n.featureInfoProductsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoProductsAddTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoProductsAddStep1Title, description: l10n.featureInfoProductsAddStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsAddStep2Title, description: l10n.featureInfoProductsAddStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsAddStep3Title, description: l10n.featureInfoProductsAddStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsAddStep4Title, description: l10n.featureInfoProductsAddStep4Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsAddStep5Title, description: l10n.featureInfoProductsAddStep5Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoProductsEditTitle,
        icon: Icons.edit_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoProductsEditStep1Title, description: l10n.featureInfoProductsEditStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsEditStep2Title, description: l10n.featureInfoProductsEditStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsEditStep3Title, description: l10n.featureInfoProductsEditStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoProductsDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoProductsDeleteStep1Title, description: l10n.featureInfoProductsDeleteStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoProductsDeleteStep2Title, description: l10n.featureInfoProductsDeleteStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoProductsTip1, l10n.featureInfoProductsTip2, l10n.featureInfoProductsTip3],
  );
}

void showCategoryListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoCategoriesTitle,
    description: l10n.featureInfoCategoriesDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoCategoriesAddTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoCategoriesAddStep1Title, description: l10n.featureInfoCategoriesAddStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoCategoriesAddStep2Title, description: l10n.featureInfoCategoriesAddStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoCategoriesAddStep3Title, description: l10n.featureInfoCategoriesAddStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoCategoriesAddStep4Title, description: l10n.featureInfoCategoriesAddStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoCategoriesEditTitle,
        icon: Icons.edit_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoCategoriesEditStep1Title, description: l10n.featureInfoCategoriesEditStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoCategoriesEditStep2Title, description: l10n.featureInfoCategoriesEditStep2Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoCategoriesDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoCategoriesDeleteStep1Title,
            description: l10n.featureInfoCategoriesDeleteStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoCategoriesDeleteStep2Title,
            description: l10n.featureInfoCategoriesDeleteStep2Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoCategoriesTip1, l10n.featureInfoCategoriesTip2],
  );
}

void showSupplierListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoSuppliersTitle,
    description: l10n.featureInfoSuppliersDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoSuppliersAddTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoSuppliersAddStep1Title, description: l10n.featureInfoSuppliersAddStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoSuppliersAddStep2Title, description: l10n.featureInfoSuppliersAddStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoSuppliersAddStep3Title, description: l10n.featureInfoSuppliersAddStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoSuppliersAddStep4Title, description: l10n.featureInfoSuppliersAddStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoSuppliersEditTitle,
        icon: Icons.edit_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoSuppliersEditStep1Title, description: l10n.featureInfoSuppliersEditStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoSuppliersEditStep2Title, description: l10n.featureInfoSuppliersEditStep2Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoSuppliersDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoSuppliersDeleteStep1Title,
            description: l10n.featureInfoSuppliersDeleteStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoSuppliersDeleteStep2Title,
            description: l10n.featureInfoSuppliersDeleteStep2Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoSuppliersTip1, l10n.featureInfoSuppliersTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// CUSTOMERS
// ─────────────────────────────────────────────────────────────

void showCustomerListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoCustomersTitle,
    description: l10n.featureInfoCustomersDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoCustomersViewTitle,
        icon: Icons.visibility_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoCustomersViewStep1Title, description: l10n.featureInfoCustomersViewStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoCustomersViewStep2Title, description: l10n.featureInfoCustomersViewStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoCustomersTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// ORDERS
// ─────────────────────────────────────────────────────────────

void showOrderListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoOrdersTitle,
    description: l10n.featureInfoOrdersDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoOrdersViewTitle,
        icon: Icons.visibility_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoOrdersViewStep1Title, description: l10n.featureInfoOrdersViewStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoOrdersViewStep2Title, description: l10n.featureInfoOrdersViewStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoOrdersViewStep3Title, description: l10n.featureInfoOrdersViewStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoOrdersVoidTitle,
        icon: Icons.block_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoOrdersVoidStep1Title, description: l10n.featureInfoOrdersVoidStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoOrdersVoidStep2Title, description: l10n.featureInfoOrdersVoidStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoOrdersTip1, l10n.featureInfoOrdersTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// STAFF
// ─────────────────────────────────────────────────────────────

void showStaffListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoStaffTitle,
    description: l10n.featureInfoStaffDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoStaffAddTitle,
        icon: Icons.person_add_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoStaffAddStep1Title, description: l10n.featureInfoStaffAddStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffAddStep2Title, description: l10n.featureInfoStaffAddStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffAddStep3Title, description: l10n.featureInfoStaffAddStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffAddStep4Title, description: l10n.featureInfoStaffAddStep4Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffAddStep5Title, description: l10n.featureInfoStaffAddStep5Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoStaffEditTitle,
        icon: Icons.edit_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoStaffEditStep1Title, description: l10n.featureInfoStaffEditStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffEditStep2Title, description: l10n.featureInfoStaffEditStep2Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoStaffDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoStaffDeleteStep1Title, description: l10n.featureInfoStaffDeleteStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoStaffDeleteStep2Title, description: l10n.featureInfoStaffDeleteStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoStaffTip1, l10n.featureInfoStaffTip2, l10n.featureInfoStaffTip3],
  );
}

void showRolesListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoRolesTitle,
    description: l10n.featureInfoRolesDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoRolesCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoRolesCreateStep1Title, description: l10n.featureInfoRolesCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoRolesCreateStep2Title, description: l10n.featureInfoRolesCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoRolesCreateStep3Title, description: l10n.featureInfoRolesCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoRolesCreateStep4Title, description: l10n.featureInfoRolesCreateStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoRolesDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoRolesDeleteStep1Title, description: l10n.featureInfoRolesDeleteStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoRolesDeleteStep2Title, description: l10n.featureInfoRolesDeleteStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoRolesTip1, l10n.featureInfoRolesTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// INVENTORY
// ─────────────────────────────────────────────────────────────

void showInventoryInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoInventoryTitle,
    description: l10n.featureInfoInventoryDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoInventoryNavigateTitle,
        icon: Icons.dashboard_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoInventoryNavigateStep1Title,
            description: l10n.featureInfoInventoryNavigateStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoInventoryNavigateStep2Title,
            description: l10n.featureInfoInventoryNavigateStep2Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoInventoryTip1, l10n.featureInfoInventoryTip2],
  );
}

void showStockAdjustmentsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoStockAdjTitle,
    description: l10n.featureInfoStockAdjDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoStockAdjCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoStockAdjCreateStep1Title, description: l10n.featureInfoStockAdjCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoStockAdjCreateStep2Title, description: l10n.featureInfoStockAdjCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoStockAdjCreateStep3Title, description: l10n.featureInfoStockAdjCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoStockAdjCreateStep4Title, description: l10n.featureInfoStockAdjCreateStep4Desc),
          FeatureGuideStep(title: l10n.featureInfoStockAdjCreateStep5Title, description: l10n.featureInfoStockAdjCreateStep5Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoStockAdjTip1, l10n.featureInfoStockAdjTip2],
  );
}

void showPurchaseOrdersInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoPOTitle,
    description: l10n.featureInfoPODesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoPOCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoPOCreateStep1Title, description: l10n.featureInfoPOCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoPOCreateStep2Title, description: l10n.featureInfoPOCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoPOCreateStep3Title, description: l10n.featureInfoPOCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoPOCreateStep4Title, description: l10n.featureInfoPOCreateStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoPOManageTitle,
        icon: Icons.settings_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoPOManageStep1Title, description: l10n.featureInfoPOManageStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoPOManageStep2Title, description: l10n.featureInfoPOManageStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoPOManageStep3Title, description: l10n.featureInfoPOManageStep3Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoPOTip1, l10n.featureInfoPOTip2],
  );
}

void showStockTransfersInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoTransfersTitle,
    description: l10n.featureInfoTransfersDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoTransfersCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoTransfersCreateStep1Title,
            description: l10n.featureInfoTransfersCreateStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTransfersCreateStep2Title,
            description: l10n.featureInfoTransfersCreateStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTransfersCreateStep3Title,
            description: l10n.featureInfoTransfersCreateStep3Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTransfersCreateStep4Title,
            description: l10n.featureInfoTransfersCreateStep4Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoTransfersManageTitle,
        icon: Icons.swap_horiz,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoTransfersManageStep1Title,
            description: l10n.featureInfoTransfersManageStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTransfersManageStep2Title,
            description: l10n.featureInfoTransfersManageStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTransfersManageStep3Title,
            description: l10n.featureInfoTransfersManageStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoTransfersTip1],
  );
}

void showGoodsReceiptsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoGRTitle,
    description: l10n.featureInfoGRDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoGRCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoGRCreateStep1Title, description: l10n.featureInfoGRCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoGRCreateStep2Title, description: l10n.featureInfoGRCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoGRCreateStep3Title, description: l10n.featureInfoGRCreateStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoGRConfirmTitle,
        icon: Icons.check_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoGRConfirmStep1Title, description: l10n.featureInfoGRConfirmStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoGRConfirmStep2Title, description: l10n.featureInfoGRConfirmStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoGRTip1],
  );
}

void showSupplierReturnsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoSRTitle,
    description: l10n.featureInfoSRDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoSRCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoSRCreateStep1Title, description: l10n.featureInfoSRCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoSRCreateStep2Title, description: l10n.featureInfoSRCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoSRCreateStep3Title, description: l10n.featureInfoSRCreateStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoSRManageTitle,
        icon: Icons.settings_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoSRManageStep1Title, description: l10n.featureInfoSRManageStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoSRManageStep2Title, description: l10n.featureInfoSRManageStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoSRManageStep3Title, description: l10n.featureInfoSRManageStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoSRManageStep4Title, description: l10n.featureInfoSRManageStep4Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoSRTip1],
  );
}

void showRecipesInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoRecipesTitle,
    description: l10n.featureInfoRecipesDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoRecipesCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoRecipesCreateStep1Title, description: l10n.featureInfoRecipesCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoRecipesCreateStep2Title, description: l10n.featureInfoRecipesCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoRecipesCreateStep3Title, description: l10n.featureInfoRecipesCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoRecipesCreateStep4Title, description: l10n.featureInfoRecipesCreateStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoRecipesDeleteTitle,
        icon: Icons.delete_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoRecipesDeleteStep1Title, description: l10n.featureInfoRecipesDeleteStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoRecipesDeleteStep2Title, description: l10n.featureInfoRecipesDeleteStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoRecipesTip1],
  );
}

void showStockLevelsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoStockLevelsTitle,
    description: l10n.featureInfoStockLevelsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoStockLevelsViewTitle,
        icon: Icons.visibility_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoStockLevelsViewStep1Title,
            description: l10n.featureInfoStockLevelsViewStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoStockLevelsViewStep2Title,
            description: l10n.featureInfoStockLevelsViewStep2Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoStockLevelsReorderTitle,
        icon: Icons.low_priority,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoStockLevelsReorderStep1Title,
            description: l10n.featureInfoStockLevelsReorderStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoStockLevelsReorderStep2Title,
            description: l10n.featureInfoStockLevelsReorderStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoStockLevelsReorderStep3Title,
            description: l10n.featureInfoStockLevelsReorderStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoStockLevelsTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// PROMOTIONS
// ─────────────────────────────────────────────────────────────

void showPromotionListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoPromotionsTitle,
    description: l10n.featureInfoPromotionsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoPromotionsCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsCreateStep1Title,
            description: l10n.featureInfoPromotionsCreateStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsCreateStep2Title,
            description: l10n.featureInfoPromotionsCreateStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsCreateStep3Title,
            description: l10n.featureInfoPromotionsCreateStep3Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsCreateStep4Title,
            description: l10n.featureInfoPromotionsCreateStep4Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsCreateStep5Title,
            description: l10n.featureInfoPromotionsCreateStep5Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoPromotionsManageTitle,
        icon: Icons.toggle_on_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsManageStep1Title,
            description: l10n.featureInfoPromotionsManageStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsManageStep2Title,
            description: l10n.featureInfoPromotionsManageStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoPromotionsManageStep3Title,
            description: l10n.featureInfoPromotionsManageStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoPromotionsTip1, l10n.featureInfoPromotionsTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// BRANCHES
// ─────────────────────────────────────────────────────────────

void showBranchListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoBranchesTitle,
    description: l10n.featureInfoBranchesDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoBranchesCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep1Title, description: l10n.featureInfoBranchesCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep2Title, description: l10n.featureInfoBranchesCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep3Title, description: l10n.featureInfoBranchesCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep4Title, description: l10n.featureInfoBranchesCreateStep4Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep5Title, description: l10n.featureInfoBranchesCreateStep5Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesCreateStep6Title, description: l10n.featureInfoBranchesCreateStep6Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoBranchesEditTitle,
        icon: Icons.edit_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoBranchesEditStep1Title, description: l10n.featureInfoBranchesEditStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoBranchesEditStep2Title, description: l10n.featureInfoBranchesEditStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoBranchesTip1, l10n.featureInfoBranchesTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// DEBITS
// ─────────────────────────────────────────────────────────────

void showDebitListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoDebitsTitle,
    description: l10n.featureInfoDebitsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoDebitsCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoDebitsCreateStep1Title, description: l10n.featureInfoDebitsCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsCreateStep2Title, description: l10n.featureInfoDebitsCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsCreateStep3Title, description: l10n.featureInfoDebitsCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsCreateStep4Title, description: l10n.featureInfoDebitsCreateStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoDebitsAllocateTitle,
        icon: Icons.account_balance_wallet_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoDebitsAllocateStep1Title, description: l10n.featureInfoDebitsAllocateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsAllocateStep2Title, description: l10n.featureInfoDebitsAllocateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsAllocateStep3Title, description: l10n.featureInfoDebitsAllocateStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoDebitsReverseTitle,
        icon: Icons.undo_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoDebitsReverseStep1Title, description: l10n.featureInfoDebitsReverseStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoDebitsReverseStep2Title, description: l10n.featureInfoDebitsReverseStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoDebitsTip1, l10n.featureInfoDebitsTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// PAYMENTS
// ─────────────────────────────────────────────────────────────

void showExpensesInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoExpensesTitle,
    description: l10n.featureInfoExpensesDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoExpensesCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoExpensesCreateStep1Title, description: l10n.featureInfoExpensesCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoExpensesCreateStep2Title, description: l10n.featureInfoExpensesCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoExpensesCreateStep3Title, description: l10n.featureInfoExpensesCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoExpensesCreateStep4Title, description: l10n.featureInfoExpensesCreateStep4Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoExpensesTip1],
  );
}

void showCashManagementInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoCashMgmtTitle,
    description: l10n.featureInfoCashMgmtDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoCashMgmtOpenTitle,
        icon: Icons.play_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoCashMgmtOpenStep1Title, description: l10n.featureInfoCashMgmtOpenStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoCashMgmtOpenStep2Title, description: l10n.featureInfoCashMgmtOpenStep2Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoCashMgmtCashInOutTitle,
        icon: Icons.swap_vert,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoCashMgmtCashInOutStep1Title,
            description: l10n.featureInfoCashMgmtCashInOutStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoCashMgmtCashInOutStep2Title,
            description: l10n.featureInfoCashMgmtCashInOutStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoCashMgmtCashInOutStep3Title,
            description: l10n.featureInfoCashMgmtCashInOutStep3Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoCashMgmtCloseTitle,
        icon: Icons.stop_circle_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoCashMgmtCloseStep1Title, description: l10n.featureInfoCashMgmtCloseStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoCashMgmtCloseStep2Title, description: l10n.featureInfoCashMgmtCloseStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoCashMgmtCloseStep3Title, description: l10n.featureInfoCashMgmtCloseStep3Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoCashMgmtTip1, l10n.featureInfoCashMgmtTip2],
  );
}

void showGiftCardsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoGiftCardsTitle,
    description: l10n.featureInfoGiftCardsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoGiftCardsIssueTitle,
        icon: Icons.card_giftcard,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoGiftCardsIssueStep1Title, description: l10n.featureInfoGiftCardsIssueStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoGiftCardsIssueStep2Title, description: l10n.featureInfoGiftCardsIssueStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoGiftCardsIssueStep3Title, description: l10n.featureInfoGiftCardsIssueStep3Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoGiftCardsCheckTitle,
        icon: Icons.search,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoGiftCardsCheckStep1Title, description: l10n.featureInfoGiftCardsCheckStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoGiftCardsCheckStep2Title, description: l10n.featureInfoGiftCardsCheckStep2Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoGiftCardsRedeemTitle,
        icon: Icons.redeem,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoGiftCardsRedeemStep1Title,
            description: l10n.featureInfoGiftCardsRedeemStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoGiftCardsRedeemStep2Title,
            description: l10n.featureInfoGiftCardsRedeemStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoGiftCardsRedeemStep3Title,
            description: l10n.featureInfoGiftCardsRedeemStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoGiftCardsTip1],
  );
}

void showCashSessionsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoCashSessionsTitle,
    description: l10n.featureInfoCashSessionsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoCashSessionsViewTitle,
        icon: Icons.visibility_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoCashSessionsViewStep1Title,
            description: l10n.featureInfoCashSessionsViewStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoCashSessionsViewStep2Title,
            description: l10n.featureInfoCashSessionsViewStep2Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoCashSessionsTip1],
  );
}

void showDailySummaryInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoDailySummaryTitle,
    description: l10n.featureInfoDailySummaryDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoDailySummaryNavigateTitle,
        icon: Icons.calendar_today,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoDailySummaryNavigateStep1Title,
            description: l10n.featureInfoDailySummaryNavigateStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoDailySummaryNavigateStep2Title,
            description: l10n.featureInfoDailySummaryNavigateStep2Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoDailySummaryReviewTitle,
        icon: Icons.assessment_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoDailySummaryReviewStep1Title,
            description: l10n.featureInfoDailySummaryReviewStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoDailySummaryReviewStep2Title,
            description: l10n.featureInfoDailySummaryReviewStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoDailySummaryReviewStep3Title,
            description: l10n.featureInfoDailySummaryReviewStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoDailySummaryTip1],
  );
}

void showFinancialReconciliationInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoFinReconTitle,
    description: l10n.featureInfoFinReconDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoFinReconStepsTitle,
        icon: Icons.checklist,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoFinReconStep1Title, description: l10n.featureInfoFinReconStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoFinReconStep2Title, description: l10n.featureInfoFinReconStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoFinReconStep3Title, description: l10n.featureInfoFinReconStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoFinReconStep4Title, description: l10n.featureInfoFinReconStep4Desc),
          FeatureGuideStep(title: l10n.featureInfoFinReconStep5Title, description: l10n.featureInfoFinReconStep5Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoFinReconTip1, l10n.featureInfoFinReconTip2],
  );
}

// ─────────────────────────────────────────────────────────────
// TRANSACTIONS
// ─────────────────────────────────────────────────────────────

void showTransactionExplorerInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoTxExplorerTitle,
    description: l10n.featureInfoTxExplorerDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoTxExplorerSearchTitle,
        icon: Icons.search,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoTxExplorerSearchStep1Title,
            description: l10n.featureInfoTxExplorerSearchStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTxExplorerSearchStep2Title,
            description: l10n.featureInfoTxExplorerSearchStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTxExplorerSearchStep3Title,
            description: l10n.featureInfoTxExplorerSearchStep3Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoTxExplorerAnalyticsTitle,
        icon: Icons.analytics_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoTxExplorerAnalyticsStep1Title,
            description: l10n.featureInfoTxExplorerAnalyticsStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoTxExplorerAnalyticsStep2Title,
            description: l10n.featureInfoTxExplorerAnalyticsStep2Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoTxExplorerTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// REPORTS
// ─────────────────────────────────────────────────────────────

void showReportsDashboardInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoReportsTitle,
    description: l10n.featureInfoReportsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoReportsNavigateTitle,
        icon: Icons.dashboard_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoReportsNavigateStep1Title,
            description: l10n.featureInfoReportsNavigateStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoReportsNavigateStep2Title,
            description: l10n.featureInfoReportsNavigateStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoReportsNavigateStep3Title,
            description: l10n.featureInfoReportsNavigateStep3Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoReportsTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// LABELS
// ─────────────────────────────────────────────────────────────

void showLabelListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoLabelsTitle,
    description: l10n.featureInfoLabelsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoLabelsCreateTitle,
        icon: Icons.add_circle_outline,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoLabelsCreateStep1Title, description: l10n.featureInfoLabelsCreateStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoLabelsCreateStep2Title, description: l10n.featureInfoLabelsCreateStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoLabelsCreateStep3Title, description: l10n.featureInfoLabelsCreateStep3Desc),
          FeatureGuideStep(title: l10n.featureInfoLabelsCreateStep4Title, description: l10n.featureInfoLabelsCreateStep4Desc),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoLabelsPrintTitle,
        icon: Icons.print_outlined,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoLabelsPrintStep1Title, description: l10n.featureInfoLabelsPrintStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoLabelsPrintStep2Title, description: l10n.featureInfoLabelsPrintStep2Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoLabelsTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// DELIVERY
// ─────────────────────────────────────────────────────────────

void showDeliveryDashboardInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoDeliveryTitle,
    description: l10n.featureInfoDeliveryDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoDeliveryPlatformsTitle,
        icon: Icons.store_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoDeliveryPlatformsStep1Title,
            description: l10n.featureInfoDeliveryPlatformsStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoDeliveryPlatformsStep2Title,
            description: l10n.featureInfoDeliveryPlatformsStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoDeliveryPlatformsStep3Title,
            description: l10n.featureInfoDeliveryPlatformsStep3Desc,
          ),
        ],
      ),
      FeatureInfoSection(
        title: l10n.featureInfoDeliveryOrdersTitle,
        icon: Icons.delivery_dining,
        steps: [
          FeatureGuideStep(title: l10n.featureInfoDeliveryOrdersStep1Title, description: l10n.featureInfoDeliveryOrdersStep1Desc),
          FeatureGuideStep(title: l10n.featureInfoDeliveryOrdersStep2Title, description: l10n.featureInfoDeliveryOrdersStep2Desc),
          FeatureGuideStep(title: l10n.featureInfoDeliveryOrdersStep3Title, description: l10n.featureInfoDeliveryOrdersStep3Desc),
        ],
      ),
    ],
    tips: [l10n.featureInfoDeliveryTip1],
  );
}

// ─────────────────────────────────────────────────────────────
// NOTIFICATIONS
// ─────────────────────────────────────────────────────────────

void showNotificationsInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showFeatureInfoDialog(
    context,
    title: l10n.featureInfoNotificationsTitle,
    description: l10n.featureInfoNotificationsDesc,
    sections: [
      FeatureInfoSection(
        title: l10n.featureInfoNotificationsManageTitle,
        icon: Icons.notifications_outlined,
        steps: [
          FeatureGuideStep(
            title: l10n.featureInfoNotificationsManageStep1Title,
            description: l10n.featureInfoNotificationsManageStep1Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoNotificationsManageStep2Title,
            description: l10n.featureInfoNotificationsManageStep2Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoNotificationsManageStep3Title,
            description: l10n.featureInfoNotificationsManageStep3Desc,
          ),
          FeatureGuideStep(
            title: l10n.featureInfoNotificationsManageStep4Title,
            description: l10n.featureInfoNotificationsManageStep4Desc,
          ),
        ],
      ),
    ],
    tips: [l10n.featureInfoNotificationsTip1],
  );
}
