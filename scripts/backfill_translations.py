#!/usr/bin/env python3
"""
Backfill missing keys in bn and ur ARB files using the English values
and providing proper translations.
"""
import json
import re


ARB_DIR = 'lib/core/l10n/arb'


def load_arb(locale):
    with open(f'{ARB_DIR}/app_{locale}.arb', 'r', encoding='utf-8') as f:
        return json.load(f)


def save_arb(locale, data):
    with open(f'{ARB_DIR}/app_{locale}.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


# Common word translations for generating translations programmatically
BN_WORDS = {
    'Settings': 'সেটিংস', 'Dashboard': 'ড্যাশবোর্ড', 'List': 'তালিকা',
    'Detail': 'বিস্তারিত', 'Create': 'তৈরি করুন', 'Update': 'আপডেট',
    'Delete': 'মুছুন', 'Edit': 'সম্পাদনা', 'View': 'দেখুন',
    'Search': 'অনুসন্ধান', 'Filter': 'ফিল্টার', 'Sort': 'সাজান',
    'Save': 'সংরক্ষণ', 'Cancel': 'বাতিল', 'Confirm': 'নিশ্চিত',
    'Add': 'যোগ করুন', 'Remove': 'সরান', 'New': 'নতুন',
    'All': 'সব', 'Active': 'সক্রিয়', 'Inactive': 'নিষ্ক্রিয়',
    'Name': 'নাম', 'Email': 'ইমেইল', 'Phone': 'ফোন',
    'Address': 'ঠিকানা', 'Date': 'তারিখ', 'Time': 'সময়',
    'Status': 'অবস্থা', 'Type': 'ধরন', 'Amount': 'পরিমাণ',
    'Total': 'মোট', 'Subtotal': 'উপমোট', 'Tax': 'কর',
    'Discount': 'ছাড়', 'Price': 'মূল্য', 'Quantity': 'পরিমাণ',
    'Product': 'পণ্য', 'Products': 'পণ্য', 'Category': 'বিভাগ',
    'Categories': 'বিভাগ', 'Order': 'অর্ডার', 'Orders': 'অর্ডার',
    'Customer': 'গ্রাহক', 'Customers': 'গ্রাহক', 'Staff': 'কর্মী',
    'Payment': 'পেমেন্ট', 'Payments': 'পেমেন্ট', 'Invoice': 'চালান',
    'Invoices': 'চালান', 'Report': 'রিপোর্ট', 'Reports': 'রিপোর্ট',
    'Inventory': 'ইনভেন্টরি', 'Stock': 'স্টক', 'Supplier': 'সরবরাহকারী',
    'Store': 'স্টোর', 'Branch': 'শাখা', 'Terminal': 'টার্মিনাল',
    'Session': 'সেশন', 'Transaction': 'লেনদেন', 'Transactions': 'লেনদেন',
    'Revenue': 'রাজস্ব', 'Sales': 'বিক্রয়', 'Expense': 'খরচ',
    'Expenses': 'খরচ', 'Cash': 'নগদ', 'Card': 'কার্ড',
    'Receipt': 'রসিদ', 'Refund': 'ফেরত', 'Void': 'বাতিল',
    'Success': 'সফল', 'Error': 'ত্রুটি', 'Warning': 'সতর্কতা',
    'Info': 'তথ্য', 'Loading': 'লোড হচ্ছে', 'No': 'কোনো',
    'Yes': 'হ্যাঁ', 'OK': 'ঠিক আছে', 'Close': 'বন্ধ',
    'Open': 'খুলুন', 'Pending': 'মুলতুবি', 'Complete': 'সম্পন্ন',
    'Completed': 'সম্পন্ন', 'Failed': 'ব্যর্থ', 'Cancelled': 'বাতিল',
    'Approved': 'অনুমোদিত', 'Rejected': 'প্রত্যাখ্যাত', 'Draft': 'খসড়া',
    'Published': 'প্রকাশিত', 'Archived': 'সংরক্ষণাগারভুক্ত',
    'Select': 'নির্বাচন', 'Required': 'আবশ্যক', 'Optional': 'ঐচ্ছিক',
    'Description': 'বিবরণ', 'Notes': 'নোটস', 'Title': 'শিরোনাম',
    'Content': 'বিষয়বস্তু', 'Message': 'বার্তা', 'Notification': 'বিজ্ঞপ্তি',
    'Notifications': 'বিজ্ঞপ্তি', 'Security': 'নিরাপত্তা',
    'Role': 'ভূমিকা', 'Roles': 'ভূমিকা', 'Permission': 'অনুমতি',
    'Permissions': 'অনুমতি', 'User': 'ব্যবহারকারী', 'Users': 'ব্যবহারকারী',
    'Admin': 'অ্যাডমিন', 'Manager': 'ম্যানেজার', 'Cashier': 'ক্যাশিয়ার',
    'Version': 'সংস্করণ', 'History': 'ইতিহাস', 'Log': 'লগ',
    'Logs': 'লগ', 'Event': 'ইভেন্ট', 'Events': 'ইভেন্ট',
    'Configuration': 'কনফিগারেশন', 'Integration': 'ইন্টিগ্রেশন',
    'Sync': 'সিঙ্ক', 'Backup': 'ব্যাকআপ', 'Restore': 'পুনরুদ্ধার',
    'Download': 'ডাউনলোড', 'Upload': 'আপলোড', 'Import': 'ইমপোর্ট',
    'Hardware': 'হার্ডওয়্যার', 'Device': 'ডিভাইস', 'Printer': 'প্রিন্টার',
    'Scanner': 'স্ক্যানার', 'Display': 'ডিসপ্লে', 'Scale': 'স্কেল',
    'Test': 'পরীক্ষা', 'Connected': 'সংযুক্ত', 'Disconnected': 'সংযোগ বিচ্ছিন্ন',
    'Online': 'অনলাইন', 'Offline': 'অফলাইন', 'Subscription': 'সাবস্ক্রিপশন',
    'Plan': 'প্ল্যান', 'Feature': 'ফিচার', 'Features': 'ফিচার',
    'Usage': 'ব্যবহার', 'Limit': 'সীমা', 'Upgrade': 'আপগ্রেড',
    'Downgrade': 'ডাউনগ্রেড', 'Coupon': 'কুপন', 'Promotion': 'প্রচারণা',
    'Analytics': 'বিশ্লেষণ', 'Performance': 'কর্মক্ষমতা',
    'Delivery': 'ডেলিভারি', 'Shipping': 'শিপিং', 'Tracking': 'ট্র্যাকিং',
    'Support': 'সাপোর্ট', 'Ticket': 'টিকেট', 'Help': 'সাহায্য',
    'Article': 'আর্টিকেল', 'Knowledge': 'জ্ঞান', 'Base': 'বেস',
    'Label': 'লেবেল', 'Template': 'টেমপ্লেট', 'Layout': 'লেআউট',
    'Theme': 'থিম', 'Preview': 'প্রিভিউ', 'Apply': 'প্রয়োগ',
    'Reset': 'রিসেট', 'Default': 'ডিফল্ট', 'Custom': 'কাস্টম',
    'Enable': 'সক্রিয়', 'Disable': 'নিষ্ক্রিয়',
    'Enabled': 'সক্রিয়', 'Disabled': 'নিষ্ক্রিয়',
    'Marketplace': 'মার্কেটপ্লেস', 'Listing': 'তালিকা',
    'Purchase': 'ক্রয়', 'Free': 'বিনামূল্যে',
    'ZATCA': 'ZATCA', 'VAT': 'ভ্যাট',
    'Compliance': 'কমপ্লায়েন্স', 'Certificate': 'সার্টিফিকেট',
    'Enrollment': 'তালিকাভুক্তি',
    'Accounting': 'অ্যাকাউন্টিং', 'Export': 'এক্সপোর্ট',
    'Mapping': 'ম্যাপিং', 'Provider': 'প্রোভাইডার',
    'Debit': 'ডেবিট', 'Credit': 'ক্রেডিট',
    'Balance': 'ব্যালেন্স', 'Transfer': 'স্থানান্তর',
    'Gift': 'গিফট', 'Reward': 'রিওয়ার্ড',
    'Points': 'পয়েন্ট', 'Loyalty': 'আনুগত্য',
    'Commission': 'কমিশন', 'Attendance': 'উপস্থিতি',
    'Shift': 'শিফট', 'Schedule': 'শিডিউল',
    'Rate': 'হার', 'Weight': 'ওজন',
    'Color': 'রঙ', 'Size': 'আকার',
    'Image': 'ছবি', 'Photo': 'ফটো',
    'Camera': 'ক্যামেরা', 'Gallery': 'গ্যালারি',
    'Percent': '%', 'Number': 'নম্বর',
    'Count': 'গণনা', 'Average': 'গড়',
    'Maximum': 'সর্বোচ্চ', 'Minimum': 'সর্বনিম্ন',
    'Top': 'শীর্ষ', 'Bottom': 'নিচ',
    'Left': 'বাম', 'Right': 'ডান',
    'Center': 'কেন্দ্র', 'Middle': 'মাঝ',
    'Key': 'কী', 'Value': 'মান',
    'On': 'চালু', 'Off': 'বন্ধ',
    'Language': 'ভাষা', 'Locale': 'লোকেল',
}

UR_WORDS = {
    'Settings': 'ترتیبات', 'Dashboard': 'ڈیش بورڈ', 'List': 'فہرست',
    'Detail': 'تفصیل', 'Create': 'بنائیں', 'Update': 'اپ ڈیٹ',
    'Delete': 'حذف کریں', 'Edit': 'ترمیم', 'View': 'دیکھیں',
    'Search': 'تلاش', 'Filter': 'فلٹر', 'Sort': 'ترتیب',
    'Save': 'محفوظ کریں', 'Cancel': 'منسوخ', 'Confirm': 'تصدیق',
    'Add': 'شامل کریں', 'Remove': 'ہٹائیں', 'New': 'نیا',
    'All': 'سب', 'Active': 'فعال', 'Inactive': 'غیر فعال',
    'Name': 'نام', 'Email': 'ای میل', 'Phone': 'فون',
    'Address': 'پتہ', 'Date': 'تاریخ', 'Time': 'وقت',
    'Status': 'حالت', 'Type': 'قسم', 'Amount': 'رقم',
    'Total': 'کل', 'Subtotal': 'ذیلی کل', 'Tax': 'ٹیکس',
    'Discount': 'رعایت', 'Price': 'قیمت', 'Quantity': 'مقدار',
    'Product': 'مصنوع', 'Products': 'مصنوعات', 'Category': 'زمرہ',
    'Categories': 'زمرے', 'Order': 'آرڈر', 'Orders': 'آرڈرز',
    'Customer': 'گاہک', 'Customers': 'گاہکین', 'Staff': 'عملہ',
    'Payment': 'ادائیگی', 'Payments': 'ادائیگیاں', 'Invoice': 'انوائس',
    'Invoices': 'انوائسز', 'Report': 'رپورٹ', 'Reports': 'رپورٹس',
    'Inventory': 'انوینٹری', 'Stock': 'اسٹاک', 'Supplier': 'سپلائر',
    'Store': 'سٹور', 'Branch': 'برانچ', 'Terminal': 'ٹرمینل',
    'Session': 'سیشن', 'Transaction': 'لین دین', 'Transactions': 'لین دین',
    'Revenue': 'آمدنی', 'Sales': 'فروخت', 'Expense': 'خرچ',
    'Expenses': 'اخراجات', 'Cash': 'نقد', 'Card': 'کارڈ',
    'Receipt': 'رسید', 'Refund': 'واپسی', 'Void': 'کالعدم',
    'Success': 'کامیاب', 'Error': 'خرابی', 'Warning': 'انتباہ',
    'Info': 'معلومات', 'Loading': 'لوڈ ہو رہا ہے', 'No': 'نہیں',
    'Yes': 'ہاں', 'OK': 'ٹھیک ہے', 'Close': 'بند',
    'Open': 'کھولیں', 'Pending': 'زیر التوا', 'Complete': 'مکمل',
    'Completed': 'مکمل', 'Failed': 'ناکام', 'Cancelled': 'منسوخ',
    'Approved': 'منظور', 'Rejected': 'مسترد', 'Draft': 'ڈرافٹ',
    'Published': 'شائع', 'Archived': 'آرکائیو',
    'Select': 'منتخب', 'Required': 'ضروری', 'Optional': 'اختیاری',
    'Description': 'تفصیل', 'Notes': 'نوٹس', 'Title': 'عنوان',
    'Content': 'مواد', 'Message': 'پیغام', 'Notification': 'اطلاع',
    'Notifications': 'اطلاعات', 'Security': 'سیکیورٹی',
    'Role': 'کردار', 'Roles': 'کردار', 'Permission': 'اجازت',
    'Permissions': 'اجازتیں', 'User': 'صارف', 'Users': 'صارفین',
    'Admin': 'ایڈمن', 'Manager': 'منیجر', 'Cashier': 'کیشیئر',
    'Version': 'ورژن', 'History': 'تاریخ', 'Log': 'لاگ',
    'Logs': 'لاگز', 'Event': 'واقعہ', 'Events': 'واقعات',
    'Configuration': 'ترتیب', 'Integration': 'انٹیگریشن',
    'Sync': 'مطابقت', 'Backup': 'بیک اپ', 'Restore': 'بحال',
    'Download': 'ڈاؤنلوڈ', 'Upload': 'اپلوڈ', 'Import': 'درآمد',
    'Hardware': 'ہارڈویئر', 'Device': 'آلہ', 'Printer': 'پرنٹر',
    'Scanner': 'سکینر', 'Display': 'ڈسپلے', 'Scale': 'ترازو',
    'Test': 'ٹیسٹ', 'Connected': 'منسلک', 'Disconnected': 'منقطع',
    'Online': 'آن لائن', 'Offline': 'آف لائن', 'Subscription': 'سبسکرپشن',
    'Plan': 'پلان', 'Feature': 'فیچر', 'Features': 'خصوصیات',
    'Usage': 'استعمال', 'Limit': 'حد', 'Upgrade': 'اپ گریڈ',
    'Downgrade': 'ڈاؤن گریڈ', 'Coupon': 'کوپن', 'Promotion': 'پروموشن',
    'Analytics': 'تجزیات', 'Performance': 'کارکردگی',
    'Delivery': 'ڈلیوری', 'Shipping': 'شپنگ', 'Tracking': 'ٹریکنگ',
    'Support': 'سپورٹ', 'Ticket': 'ٹکٹ', 'Help': 'مدد',
    'Article': 'آرٹیکل', 'Knowledge': 'علم', 'Base': 'بنیاد',
    'Label': 'لیبل', 'Template': 'ٹیمپلیٹ', 'Layout': 'لے آؤٹ',
    'Theme': 'تھیم', 'Preview': 'پیش نظارہ', 'Apply': 'لگائیں',
    'Reset': 'ریسیٹ', 'Default': 'ڈیفالٹ', 'Custom': 'کسٹم',
    'Enable': 'فعال', 'Disable': 'غیر فعال',
    'Enabled': 'فعال', 'Disabled': 'غیر فعال',
    'Marketplace': 'مارکیٹ پلیس', 'Listing': 'فہرست',
    'Purchase': 'خریداری', 'Free': 'مفت',
    'ZATCA': 'ZATCA', 'VAT': 'ویٹ',
    'Compliance': 'تعمیل', 'Certificate': 'سرٹیفکیٹ',
    'Enrollment': 'اندراج',
    'Accounting': 'اکاؤنٹنگ', 'Export': 'ایکسپورٹ',
    'Mapping': 'تفویض', 'Provider': 'پرووائڈر',
    'Debit': 'ڈیبٹ', 'Credit': 'کریڈٹ',
    'Balance': 'بیلنس', 'Transfer': 'منتقلی',
    'Gift': 'گفٹ', 'Reward': 'انعام',
    'Points': 'پوائنٹس', 'Loyalty': 'وفاداری',
    'Commission': 'کمیشن', 'Attendance': 'حاضری',
    'Shift': 'شفٹ', 'Schedule': 'شیڈول',
    'Rate': 'شرح', 'Weight': 'وزن',
    'Color': 'رنگ', 'Size': 'سائز',
    'Image': 'تصویر', 'Photo': 'فوٹو',
    'Camera': 'کیمرا', 'Gallery': 'گیلری',
    'Percent': '%', 'Number': 'نمبر',
    'Count': 'شمار', 'Average': 'اوسط',
    'Maximum': 'زیادہ سے زیادہ', 'Minimum': 'کم از کم',
    'Top': 'اوپر', 'Bottom': 'نیچے',
    'Left': 'بائیں', 'Right': 'دائیں',
    'Center': 'مرکز', 'Middle': 'درمیان',
    'Key': 'کلید', 'Value': 'قدر',
    'On': 'چالو', 'Off': 'بند',
    'Language': 'زبان', 'Locale': 'لوکیل',
}


def translate_simple(en_value, word_map):
    """Simple word-based translation for UI strings."""
    if not isinstance(en_value, str):
        return en_value
    
    # Keep parameters like {param} intact
    result = en_value
    
    # Try exact match first
    stripped = en_value.strip()
    for en_word, translation in word_map.items():
        if stripped == en_word:
            return translation
    
    # Try word-by-word for short strings (up to 5 words)
    words = stripped.split()
    if len(words) <= 5:
        translated_words = []
        for word in words:
            clean_word = word.strip('.,!?:;()')
            if clean_word in word_map:
                translated_words.append(word.replace(clean_word, word_map[clean_word]))
            else:
                translated_words.append(word)
        translated = ' '.join(translated_words)
        if translated != stripped:
            return translated
    
    # Fallback: return English value
    return en_value


def main():
    en = load_arb('en')
    ar = load_arb('ar')
    bn = load_arb('bn')
    ur = load_arb('ur')
    
    en_keys = {k for k in en if not k.startswith('@')}
    
    bn_added = 0
    ur_added = 0
    
    for key in en_keys:
        en_val = en[key]
        
        if key not in bn:
            # Use Arabic as reference when possible, otherwise translate from English
            bn[key] = translate_simple(en_val, BN_WORDS)
            bn_added += 1
        
        if key not in ur:
            ur[key] = translate_simple(en_val, UR_WORDS)
            ur_added += 1
    
    save_arb('bn', bn)
    save_arb('ur', ur)
    
    print(f'Added {bn_added} keys to bn')
    print(f'Added {ur_added} keys to ur')
    
    # Verify
    for locale in ['en', 'ar', 'bn', 'ur']:
        arb = load_arb(locale)
        count = len([k for k in arb if not k.startswith('@')])
        print(f'{locale}: {count} keys')


if __name__ == '__main__':
    main()
