import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/branches/enums/business_type.dart';
import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/branches/providers/branch_providers.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';

class BranchFormPage extends ConsumerStatefulWidget {
  final Store? existingBranch;
  const BranchFormPage({super.key, this.existingBranch});

  @override
  ConsumerState<BranchFormPage> createState() => _BranchFormPageState();
}

class _BranchFormPageState extends ConsumerState<BranchFormPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.existingBranch != null;

  // Basic Info
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _branchCodeCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _descriptionArCtrl;
  BusinessType? _businessType;
  late final TextEditingController _timezoneCtrl;
  late final TextEditingController _currencyCtrl;
  late final TextEditingController _localeCtrl;

  // Location
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _regionCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _googleMapsUrlCtrl;
  late final TextEditingController _latitudeCtrl;
  late final TextEditingController _longitudeCtrl;

  // Contact
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _secondaryPhoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _contactPersonCtrl;

  // Operational
  late final TextEditingController _openingDateCtrl;
  late final TextEditingController _closingDateCtrl;
  late final TextEditingController _maxRegistersCtrl;
  late final TextEditingController _maxStaffCtrl;
  late final TextEditingController _areaSqmCtrl;
  late final TextEditingController _seatingCapacityCtrl;

  // Flags
  bool _isMainBranch = false;
  bool _isWarehouse = false;
  bool _acceptsOnlineOrders = false;
  bool _acceptsReservations = false;
  bool _hasDelivery = false;
  bool _hasPickup = false;

  // Legal
  late final TextEditingController _crNumberCtrl;
  late final TextEditingController _vatNumberCtrl;
  late final TextEditingController _municipalLicenseCtrl;
  late final TextEditingController _licenseExpiryDateCtrl;

  // Social
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _twitterCtrl;
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _websiteCtrl;
  late final TextEditingController _tiktokCtrl;
  late final TextEditingController _snapchatCtrl;

  // Media & Notes
  late final TextEditingController _logoUrlCtrl;
  late final TextEditingController _coverImageUrlCtrl;
  late final TextEditingController _internalNotesCtrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    final b = widget.existingBranch;
    _nameCtrl = TextEditingController(text: b?.name ?? '');
    _nameArCtrl = TextEditingController(text: b?.nameAr ?? '');
    _branchCodeCtrl = TextEditingController(text: b?.branchCode ?? '');
    _descriptionCtrl = TextEditingController(text: b?.description ?? '');
    _descriptionArCtrl = TextEditingController(text: b?.descriptionAr ?? '');
    _businessType = b?.businessType;
    _timezoneCtrl = TextEditingController(text: b?.timezone ?? '');
    _currencyCtrl = TextEditingController(text: b?.currency ?? '');
    _localeCtrl = TextEditingController(text: b?.locale ?? '');
    _addressCtrl = TextEditingController(text: b?.address ?? '');
    _cityCtrl = TextEditingController(text: b?.city ?? '');
    _regionCtrl = TextEditingController(text: b?.region ?? '');
    _postalCodeCtrl = TextEditingController(text: b?.postalCode ?? '');
    _countryCtrl = TextEditingController(text: b?.country ?? '');
    _googleMapsUrlCtrl = TextEditingController(text: b?.googleMapsUrl ?? '');
    _latitudeCtrl = TextEditingController(text: b?.latitude?.toString() ?? '');
    _longitudeCtrl = TextEditingController(text: b?.longitude?.toString() ?? '');
    _phoneCtrl = TextEditingController(text: b?.phone ?? '');
    _secondaryPhoneCtrl = TextEditingController(text: b?.secondaryPhone ?? '');
    _emailCtrl = TextEditingController(text: b?.email ?? '');
    _contactPersonCtrl = TextEditingController(text: b?.contactPerson ?? '');
    _openingDateCtrl = TextEditingController(text: b?.openingDate ?? '');
    _closingDateCtrl = TextEditingController(text: b?.closingDate ?? '');
    _maxRegistersCtrl = TextEditingController(text: b?.maxRegisters?.toString() ?? '');
    _maxStaffCtrl = TextEditingController(text: b?.maxStaff?.toString() ?? '');
    _areaSqmCtrl = TextEditingController(text: b?.areaSqm?.toString() ?? '');
    _seatingCapacityCtrl = TextEditingController(text: b?.seatingCapacity?.toString() ?? '');
    _isMainBranch = b?.isMainBranch ?? false;
    _isWarehouse = b?.isWarehouse ?? false;
    _acceptsOnlineOrders = b?.acceptsOnlineOrders ?? false;
    _acceptsReservations = b?.acceptsReservations ?? false;
    _hasDelivery = b?.hasDelivery ?? false;
    _hasPickup = b?.hasPickup ?? false;
    _crNumberCtrl = TextEditingController(text: b?.crNumber ?? '');
    _vatNumberCtrl = TextEditingController(text: b?.vatNumber ?? '');
    _municipalLicenseCtrl = TextEditingController(text: b?.municipalLicense ?? '');
    _licenseExpiryDateCtrl = TextEditingController(text: b?.licenseExpiryDate ?? '');
    final social = b?.socialLinks ?? {};
    _instagramCtrl = TextEditingController(text: social['instagram'] as String? ?? '');
    _twitterCtrl = TextEditingController(text: social['twitter'] as String? ?? '');
    _facebookCtrl = TextEditingController(text: social['facebook'] as String? ?? '');
    _websiteCtrl = TextEditingController(text: social['website'] as String? ?? '');
    _tiktokCtrl = TextEditingController(text: social['tiktok'] as String? ?? '');
    _snapchatCtrl = TextEditingController(text: social['snapchat'] as String? ?? '');
    _logoUrlCtrl = TextEditingController(text: b?.logoUrl ?? '');
    _coverImageUrlCtrl = TextEditingController(text: b?.coverImageUrl ?? '');
    _internalNotesCtrl = TextEditingController(text: b?.internalNotes ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in [
      _nameCtrl,
      _nameArCtrl,
      _branchCodeCtrl,
      _descriptionCtrl,
      _descriptionArCtrl,
      _timezoneCtrl,
      _currencyCtrl,
      _localeCtrl,
      _addressCtrl,
      _cityCtrl,
      _regionCtrl,
      _postalCodeCtrl,
      _countryCtrl,
      _googleMapsUrlCtrl,
      _latitudeCtrl,
      _longitudeCtrl,
      _phoneCtrl,
      _secondaryPhoneCtrl,
      _emailCtrl,
      _contactPersonCtrl,
      _openingDateCtrl,
      _closingDateCtrl,
      _maxRegistersCtrl,
      _maxStaffCtrl,
      _areaSqmCtrl,
      _seatingCapacityCtrl,
      _crNumberCtrl,
      _vatNumberCtrl,
      _municipalLicenseCtrl,
      _licenseExpiryDateCtrl,
      _instagramCtrl,
      _twitterCtrl,
      _facebookCtrl,
      _websiteCtrl,
      _tiktokCtrl,
      _snapchatCtrl,
      _logoUrlCtrl,
      _coverImageUrlCtrl,
      _internalNotesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _collectData() {
    final data = <String, dynamic>{'name': _nameCtrl.text.trim()};

    void addIfNotEmpty(String key, String value) {
      if (value.isNotEmpty) data[key] = value;
    }

    void addIfNotEmptyNum(String key, String value) {
      if (value.isNotEmpty) {
        final n = num.tryParse(value);
        if (n != null) data[key] = n;
      }
    }

    addIfNotEmpty('name_ar', _nameArCtrl.text.trim());
    addIfNotEmpty('branch_code', _branchCodeCtrl.text.trim());
    addIfNotEmpty('description', _descriptionCtrl.text.trim());
    addIfNotEmpty('description_ar', _descriptionArCtrl.text.trim());
    if (_businessType != null) data['business_type'] = _businessType!.value;
    addIfNotEmpty('timezone', _timezoneCtrl.text.trim());
    addIfNotEmpty('currency', _currencyCtrl.text.trim());
    addIfNotEmpty('locale', _localeCtrl.text.trim());
    addIfNotEmpty('address', _addressCtrl.text.trim());
    addIfNotEmpty('city', _cityCtrl.text.trim());
    addIfNotEmpty('region', _regionCtrl.text.trim());
    addIfNotEmpty('postal_code', _postalCodeCtrl.text.trim());
    addIfNotEmpty('country', _countryCtrl.text.trim());
    addIfNotEmpty('google_maps_url', _googleMapsUrlCtrl.text.trim());
    addIfNotEmptyNum('latitude', _latitudeCtrl.text.trim());
    addIfNotEmptyNum('longitude', _longitudeCtrl.text.trim());
    addIfNotEmpty('phone', _phoneCtrl.text.trim());
    addIfNotEmpty('secondary_phone', _secondaryPhoneCtrl.text.trim());
    addIfNotEmpty('email', _emailCtrl.text.trim());
    addIfNotEmpty('contact_person', _contactPersonCtrl.text.trim());
    addIfNotEmpty('opening_date', _openingDateCtrl.text.trim());
    addIfNotEmpty('closing_date', _closingDateCtrl.text.trim());
    addIfNotEmptyNum('max_registers', _maxRegistersCtrl.text.trim());
    addIfNotEmptyNum('max_staff', _maxStaffCtrl.text.trim());
    addIfNotEmptyNum('area_sqm', _areaSqmCtrl.text.trim());
    addIfNotEmptyNum('seating_capacity', _seatingCapacityCtrl.text.trim());

    data['is_main_branch'] = _isMainBranch;
    data['is_warehouse'] = _isWarehouse;
    data['accepts_online_orders'] = _acceptsOnlineOrders;
    data['accepts_reservations'] = _acceptsReservations;
    data['has_delivery'] = _hasDelivery;
    data['has_pickup'] = _hasPickup;

    addIfNotEmpty('cr_number', _crNumberCtrl.text.trim());
    addIfNotEmpty('vat_number', _vatNumberCtrl.text.trim());
    addIfNotEmpty('municipal_license', _municipalLicenseCtrl.text.trim());
    addIfNotEmpty('license_expiry_date', _licenseExpiryDateCtrl.text.trim());

    final socialLinks = <String, String>{};
    void addSocial(String key, String value) {
      if (value.isNotEmpty) socialLinks[key] = value;
    }

    addSocial('instagram', _instagramCtrl.text.trim());
    addSocial('twitter', _twitterCtrl.text.trim());
    addSocial('facebook', _facebookCtrl.text.trim());
    addSocial('website', _websiteCtrl.text.trim());
    addSocial('tiktok', _tiktokCtrl.text.trim());
    addSocial('snapchat', _snapchatCtrl.text.trim());
    if (socialLinks.isNotEmpty) data['social_links'] = socialLinks;

    addIfNotEmpty('logo_url', _logoUrlCtrl.text.trim());
    addIfNotEmpty('cover_image_url', _coverImageUrlCtrl.text.trim());
    addIfNotEmpty('internal_notes', _internalNotesCtrl.text.trim());

    return data;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(branchFormProvider.notifier);
    if (_isEditing) {
      await notifier.update(widget.existingBranch!.id, _collectData());
    } else {
      await notifier.create(_collectData());
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final initial = DateTime.tryParse(controller.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<BranchFormState>(branchFormProvider, (prev, next) {
      if (next is BranchFormSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(branchListProvider.notifier).load();
        ref.read(branchFormProvider.notifier).reset();
        context.pop();
      } else if (next is BranchFormError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    final formState = ref.watch(branchFormProvider);
    final isSaving = formState is BranchFormSaving;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(_isEditing ? l10n.branchesEditBranch : l10n.branchesCreateBranch),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: l10n.branchesBasicInfo),
            Tab(text: l10n.branchesLocation),
            Tab(text: l10n.branchesContact),
            Tab(text: l10n.branchesOperational),
            Tab(text: l10n.branchesLegal),
            Tab(text: l10n.branchesSocialInfo),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: PosButton(
              label: _isEditing ? l10n.branchesUpdated.split(' ').first : l10n.branchesCreated.split(' ').first,
              size: PosButtonSize.sm,
              isLoading: isSaving,
              onPressed: isSaving ? null : _save,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _basicInfoTab(l10n),
            _locationTab(l10n),
            _contactTab(l10n),
            _operationalTab(l10n),
            _legalTab(l10n),
            _socialTab(l10n),
          ],
        ),
      ),
    );
  }

  Widget _basicInfoTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _field(l10n.branchesBranchName, _nameCtrl, required: true),
          _field(l10n.branchesBranchNameAr, _nameArCtrl),
          _field(l10n.branchesBranchCode, _branchCodeCtrl),
          _field(l10n.branchesDescription, _descriptionCtrl, maxLines: 3),
          _field(l10n.branchesDescriptionAr, _descriptionArCtrl, maxLines: 3),
          _dropdown(l10n.branchesBusinessType),
          _field(l10n.branchesTimezone, _timezoneCtrl, hint: 'Asia/Muscat'),
          _field(l10n.branchesCurrency, _currencyCtrl, hint: 'SAR'),
          _field(l10n.branchesLocale, _localeCtrl, hint: 'ar'),
          AppSpacing.gapH16,
          _sectionLabel(l10n.branchesFlags),
          _switch(l10n.branchesIsMainBranch, _isMainBranch, (v) => setState(() => _isMainBranch = v)),
          _switch(l10n.branchesIsWarehouse, _isWarehouse, (v) => setState(() => _isWarehouse = v)),
          _switch(l10n.branchesAcceptsOnlineOrders, _acceptsOnlineOrders, (v) => setState(() => _acceptsOnlineOrders = v)),
          _switch(l10n.branchesAcceptsReservations, _acceptsReservations, (v) => setState(() => _acceptsReservations = v)),
          _switch(l10n.branchesHasDelivery, _hasDelivery, (v) => setState(() => _hasDelivery = v)),
          _switch(l10n.branchesHasPickup, _hasPickup, (v) => setState(() => _hasPickup = v)),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _locationTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _field(l10n.branchesAddress, _addressCtrl),
          _field(l10n.branchesCity, _cityCtrl),
          _field(l10n.branchesRegion, _regionCtrl),
          _field(l10n.branchesPostalCode, _postalCodeCtrl),
          _field(l10n.branchesCountry, _countryCtrl, hint: 'OM'),
          _field(l10n.branchesGoogleMapsUrl, _googleMapsUrlCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesLatitude, _latitudeCtrl, keyboard: const TextInputType.numberWithOptions(decimal: true)),
          _field(l10n.branchesLongitude, _longitudeCtrl, keyboard: const TextInputType.numberWithOptions(decimal: true)),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _contactTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _field(l10n.branchesPhone, _phoneCtrl, keyboard: TextInputType.phone),
          _field(l10n.branchesSecondaryPhone, _secondaryPhoneCtrl, keyboard: TextInputType.phone),
          _field(l10n.branchesEmail, _emailCtrl, keyboard: TextInputType.emailAddress),
          _field(l10n.branchesContactPerson, _contactPersonCtrl),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _operationalTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _dateField(l10n.branchesOpeningDate, _openingDateCtrl),
          _dateField(l10n.branchesClosingDate, _closingDateCtrl),
          _field(l10n.branchesMaxRegisters, _maxRegistersCtrl, keyboard: TextInputType.number),
          _field(l10n.branchesMaxStaff, _maxStaffCtrl, keyboard: TextInputType.number),
          _field(l10n.branchesAreaSqm, _areaSqmCtrl, keyboard: const TextInputType.numberWithOptions(decimal: true)),
          _field(l10n.branchesSeatingCapacity, _seatingCapacityCtrl, keyboard: TextInputType.number),
          AppSpacing.gapH16,
          _sectionLabel(l10n.branchesMedia),
          _field(l10n.branchesLogoUrl, _logoUrlCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesCoverImageUrl, _coverImageUrlCtrl, keyboard: TextInputType.url),
          AppSpacing.gapH16,
          _sectionLabel(l10n.branchesInternalNotes),
          _field(l10n.branchesInternalNotes, _internalNotesCtrl, maxLines: 4),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _legalTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _field(l10n.branchesCrNumber, _crNumberCtrl),
          _field(l10n.branchesVatNumber, _vatNumberCtrl),
          _field(l10n.branchesMunicipalLicense, _municipalLicenseCtrl),
          _dateField(l10n.branchesLicenseExpiryDate, _licenseExpiryDateCtrl),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  Widget _socialTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          _field(l10n.branchesInstagram, _instagramCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesTwitter, _twitterCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesFacebook, _facebookCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesWebsite, _websiteCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesTiktok, _tiktokCtrl, keyboard: TextInputType.url),
          _field(l10n.branchesSnapchat, _snapchatCtrl, keyboard: TextInputType.url),
          AppSpacing.gapH32,
        ],
      ),
    );
  }

  // ─── Helpers ───

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    bool required = false,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null : null,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, TextEditingController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () => _pickDate(controller),
            decoration: InputDecoration(
              hintText: 'YYYY-MM-DD',
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              suffixIcon: const Icon(Icons.calendar_today, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<BusinessType>(
            value: _businessType,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? AppColors.inputBgDark : AppColors.inputBgLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              isDense: true,
            ),
            items: BusinessType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.value))).toList(),
            onChanged: (v) => setState(() => _businessType = v),
          ),
        ],
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: SwitchListTile(
        title: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        value: value,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: onChanged,
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ),
    );
  }
}
