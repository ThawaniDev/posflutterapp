/// Defines what input parameters each AI feature requires before invocation.

enum FeatureFieldType {
  text,
  number,
  date,
  dateRange,
  period, // dropdown: last_7_days, last_30_days, last_90_days
  image,
  product, // product picker
  category, // category picker
  barcode,
  language, // ar / en
  platform, // social platform picker
  multilineText,
  options, // custom dropdown
}

class FeatureField {
  final String key;
  final String label;
  final String labelAr;
  final FeatureFieldType type;
  final bool required;
  final String? hint;
  final String? hintAr;
  final dynamic defaultValue;
  final List<FeatureFieldOption>? options;

  const FeatureField({
    required this.key,
    required this.label,
    required this.labelAr,
    required this.type,
    this.required = true,
    this.hint,
    this.hintAr,
    this.defaultValue,
    this.options,
  });
}

class FeatureFieldOption {
  final String value;
  final String label;
  final String labelAr;

  const FeatureFieldOption({required this.value, required this.label, required this.labelAr});
}

class FeatureInputConfig {
  final String slug;
  final List<FeatureField> fields;
  final String promptTemplate;

  const FeatureInputConfig({required this.slug, required this.fields, required this.promptTemplate});

  bool get hasRequiredFields => fields.any((f) => f.required);

  /// Static registry of feature input requirements.
  /// Features NOT listed here have no required inputs (auto-analysis).
  static const Map<String, FeatureInputConfig> featureInputConfigs = {
    // ─── INVENTORY ────────────────────────────────────────
    'expiry_manager': FeatureInputConfig(
      slug: 'expiry_manager',
      fields: [
        FeatureField(
          key: 'days_ahead',
          label: 'Days Ahead',
          labelAr: 'عدد الأيام القادمة',
          type: FeatureFieldType.number,
          required: false,
          hint: 'Default: 30 days',
          hintAr: 'الافتراضي: 30 يوم',
          defaultValue: 30,
        ),
      ],
      promptTemplate: 'Check for products expiring within the next {days_ahead} days',
    ),

    // ─── SALES ────────────────────────────────────────────
    'daily_summary': FeatureInputConfig(
      slug: 'daily_summary',
      fields: [
        FeatureField(
          key: 'date',
          label: 'Date',
          labelAr: 'التاريخ',
          type: FeatureFieldType.date,
          required: true,
          hint: 'Select the date to summarize',
          hintAr: 'اختر التاريخ للتلخيص',
        ),
      ],
      promptTemplate: 'Generate a daily sales summary for {date}',
    ),
    'sales_forecast': FeatureInputConfig(
      slug: 'sales_forecast',
      fields: [
        FeatureField(
          key: 'days',
          label: 'Forecast Period (days)',
          labelAr: 'فترة التنبؤ (أيام)',
          type: FeatureFieldType.number,
          required: false,
          hint: 'Default: 7 days',
          hintAr: 'الافتراضي: 7 أيام',
          defaultValue: 7,
        ),
      ],
      promptTemplate: 'Forecast my sales for the next {days} days',
    ),
    'peak_hours': FeatureInputConfig(
      slug: 'peak_hours',
      fields: [
        FeatureField(
          key: 'period',
          label: 'Analysis Period',
          labelAr: 'فترة التحليل',
          type: FeatureFieldType.period,
          required: false,
          defaultValue: 'last_30_days',
        ),
      ],
      promptTemplate: 'Analyze peak hours for {period}',
    ),

    // ─── CATALOG ──────────────────────────────────────────
    'invoice_ocr': FeatureInputConfig(
      slug: 'invoice_ocr',
      fields: [
        FeatureField(
          key: 'image',
          label: 'Invoice Image',
          labelAr: 'صورة الفاتورة',
          type: FeatureFieldType.image,
          required: true,
          hint: 'Take a photo or upload an invoice image',
          hintAr: 'التقط صورة أو ارفع صورة فاتورة',
        ),
      ],
      promptTemplate: 'Extract and process this invoice image',
    ),
    'product_description': FeatureInputConfig(
      slug: 'product_description',
      fields: [
        FeatureField(
          key: 'product',
          label: 'Product',
          labelAr: 'المنتج',
          type: FeatureFieldType.product,
          required: true,
          hint: 'Select a product to generate description for',
          hintAr: 'اختر المنتج لإنشاء وصف له',
        ),
      ],
      promptTemplate: 'Generate a compelling product description for {product}',
    ),
    'barcode_enrichment': FeatureInputConfig(
      slug: 'barcode_enrichment',
      fields: [
        FeatureField(
          key: 'barcode',
          label: 'Barcode',
          labelAr: 'الباركود',
          type: FeatureFieldType.barcode,
          required: true,
          hint: 'Enter or scan a barcode',
          hintAr: 'أدخل أو امسح الباركود',
        ),
      ],
      promptTemplate: 'Look up product information for barcode: {barcode}',
    ),

    // ─── CUSTOMER ─────────────────────────────────────────
    'personalized_promotions': FeatureInputConfig(
      slug: 'personalized_promotions',
      fields: [
        FeatureField(
          key: 'segment',
          label: 'Customer Segment',
          labelAr: 'شريحة العملاء',
          type: FeatureFieldType.options,
          required: false,
          hint: 'Optional: target a specific segment',
          hintAr: 'اختياري: استهداف شريحة محددة',
          options: [
            FeatureFieldOption(value: 'vip', label: 'VIP Customers', labelAr: 'عملاء VIP'),
            FeatureFieldOption(value: 'new', label: 'New Customers', labelAr: 'عملاء جدد'),
            FeatureFieldOption(value: 'at_risk', label: 'At-Risk (Churning)', labelAr: 'معرضون للانسحاب'),
            FeatureFieldOption(value: 'frequent', label: 'Frequent Buyers', labelAr: 'مشترون متكررون'),
            FeatureFieldOption(value: 'all', label: 'All Customers', labelAr: 'جميع العملاء'),
          ],
        ),
      ],
      promptTemplate: 'Generate personalized promotions for {segment} customers',
    ),

    // ─── OPERATIONS ───────────────────────────────────────
    'smart_search': FeatureInputConfig(
      slug: 'smart_search',
      fields: [
        FeatureField(
          key: 'query',
          label: 'Search Query',
          labelAr: 'استعلام البحث',
          type: FeatureFieldType.text,
          required: true,
          hint: 'What would you like to find?',
          hintAr: 'ما الذي تبحث عنه؟',
        ),
      ],
      promptTemplate: '{query}',
    ),

    // ─── COMMUNICATION ────────────────────────────────────
    'marketing_generator': FeatureInputConfig(
      slug: 'marketing_generator',
      fields: [
        FeatureField(
          key: 'type',
          label: 'Message Type',
          labelAr: 'نوع الرسالة',
          type: FeatureFieldType.options,
          required: true,
          options: [
            FeatureFieldOption(value: 'sms', label: 'SMS', labelAr: 'رسالة نصية'),
            FeatureFieldOption(value: 'whatsapp', label: 'WhatsApp', labelAr: 'واتساب'),
            FeatureFieldOption(value: 'email', label: 'Email', labelAr: 'بريد إلكتروني'),
          ],
        ),
        FeatureField(
          key: 'context_info',
          label: 'What is the message about?',
          labelAr: 'ما موضوع الرسالة؟',
          type: FeatureFieldType.multilineText,
          required: true,
          hint: 'e.g., Ramadan sale, new product launch, loyalty reward...',
          hintAr: 'مثل: تخفيضات رمضان، إطلاق منتج جديد، مكافأة الولاء...',
        ),
      ],
      promptTemplate: 'Generate a {type} marketing message about: {context_info}',
    ),
    'social_content': FeatureInputConfig(
      slug: 'social_content',
      fields: [
        FeatureField(
          key: 'platform',
          label: 'Social Platform',
          labelAr: 'منصة التواصل',
          type: FeatureFieldType.platform,
          required: true,
          options: [
            FeatureFieldOption(value: 'instagram', label: 'Instagram', labelAr: 'إنستغرام'),
            FeatureFieldOption(value: 'tiktok', label: 'TikTok', labelAr: 'تيك توك'),
            FeatureFieldOption(value: 'facebook', label: 'Facebook', labelAr: 'فيسبوك'),
            FeatureFieldOption(value: 'x', label: 'X (Twitter)', labelAr: 'إكس (تويتر)'),
            FeatureFieldOption(value: 'snapchat', label: 'Snapchat', labelAr: 'سناب شات'),
          ],
        ),
        FeatureField(
          key: 'topic',
          label: 'Content Topic',
          labelAr: 'موضوع المحتوى',
          type: FeatureFieldType.text,
          required: true,
          hint: 'e.g., Summer collection, Store opening, Flash sale',
          hintAr: 'مثل: مجموعة الصيف، افتتاح المتجر، تخفيضات سريعة',
        ),
        FeatureField(
          key: 'product',
          label: 'Featured Product',
          labelAr: 'المنتج المميز',
          type: FeatureFieldType.product,
          required: false,
          hint: 'Optional: highlight a specific product',
          hintAr: 'اختياري: تسليط الضوء على منتج محدد',
        ),
      ],
      promptTemplate: 'Create {platform} content about: {topic}',
    ),
    'translation': FeatureInputConfig(
      slug: 'translation',
      fields: [
        FeatureField(
          key: 'source_language',
          label: 'From Language',
          labelAr: 'من لغة',
          type: FeatureFieldType.language,
          required: false,
          defaultValue: 'auto',
          options: [
            FeatureFieldOption(value: 'auto', label: 'Auto-detect', labelAr: 'كشف تلقائي'),
            FeatureFieldOption(value: 'ar', label: 'Arabic', labelAr: 'العربية'),
            FeatureFieldOption(value: 'en', label: 'English', labelAr: 'الإنجليزية'),
          ],
        ),
        FeatureField(
          key: 'target_language',
          label: 'To Language',
          labelAr: 'إلى لغة',
          type: FeatureFieldType.options,
          required: true,
          options: [
            FeatureFieldOption(value: 'ar', label: 'Arabic', labelAr: 'العربية'),
            FeatureFieldOption(value: 'en', label: 'English', labelAr: 'الإنجليزية'),
          ],
        ),
        FeatureField(
          key: 'text',
          label: 'Text to Translate',
          labelAr: 'النص للترجمة',
          type: FeatureFieldType.multilineText,
          required: true,
          hint: 'Enter the text you want to translate',
          hintAr: 'أدخل النص الذي تريد ترجمته',
        ),
      ],
      promptTemplate: 'Translate the following from {source_language} to {target_language}: {text}',
    ),
  };
}
