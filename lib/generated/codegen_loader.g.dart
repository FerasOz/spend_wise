// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ar = {
  "app": {
    "title": "سبند وايز",
    "about": "حول",
    "settings": "الإعدادات"
  },
  "navigation": {
    "dashboard": "الرئيسية",
    "expenses": "المصاريف",
    "recurring": "المتكررة",
    "categories": "الفئات",
    "budgets": "الميزانيات",
    "insights": "الرؤى",
    "export": "تصدير"
  },
  "common": {
    "loading": "جارٍ التحميل...",
    "error": "حدث خطأ ما",
    "success": "تم بنجاح",
    "confirmation": "هل أنت متأكد؟",
    "actions": {
      "save": "حفظ",
      "cancel": "إلغاء",
      "delete": "حذف",
      "edit": "تعديل",
      "close": "إغلاق",
      "apply": "تطبيق",
      "reset": "إعادة ضبط",
      "tryAgain": "حاول مرة أخرى",
      "share": "مشاركة"
    },
    "validation": {
      "required": "هذا الحقل مطلوب",
      "invalid": "يرجى إدخال قيمة صحيحة",
      "minLength": "يجب أن يكون على الأقل {min} أحرف",
      "maxLength": "يجب ألا يتجاوز {max} أحرف"
    },
    "errors": {
      "loadBudgets": "تعذر تحميل الميزانيات.",
      "loadRecurringExpenses": "تعذر تحميل المصاريف المتكررة.",
      "budgetActionFailed": "فشلت عملية الميزانية."
    }
  },
  "currency": {
    "selection": "اختر العملة",
    "names": {
      "USD": "الدولار الأمريكي",
      "EUR": "اليورو",
      "ILS": "الشيكل الإسرائيلي",
      "JOD": "الدينار الأردني",
      "SAR": "الريال السعودي",
      "GBP": "الجنيه الإسترليني"
    }
  },
  "settings": {
    "preferences": {
      "title": "التفضيلات",
      "currency": {
        "title": "العملة",
        "subtitle": "حدد العملة الافتراضية لعرض المبالغ"
      },
      "language": {
        "title": "اللغة",
        "subtitle": "غيّر لغة التطبيق"
      }
    },
    "languages": {
      "english": "الإنجليزية",
      "arabic": "العربية",
      "englishNative": "English",
      "arabicNative": "العربية"
    }
  },
  "budgets": {
    "title": "الميزانيات",
    "empty": {
      "title": "لا توجد ميزانيات بعد",
      "subtitle": "أنشئ ميزانية لفئة حتى تتابع إنفاقك الشهري بشكل أفضل.",
      "button": "إنشاء ميزانية"
    },
    "card": {
      "edit": "تعديل",
      "delete": "حذف",
      "saveChanges": "حفظ التعديلات",
      "createBudget": "إنشاء ميزانية",
      "of": "من"
    },
    "remaining": "متبقي",
    "success": {
      "created": "تم إنشاء الميزانية بنجاح.",
      "updated": "تم تحديث الميزانية بنجاح.",
      "deleted": "تم حذف الميزانية بنجاح."
    },
    "form": {
      "title": {
        "create": "إنشاء ميزانية",
        "edit": "تعديل الميزانية"
      },
      "fields": {
        "name": "الاسم",
        "amount": "المبلغ",
        "period": "الفترة",
        "startDate": "تاريخ البداية",
        "endDate": "تاريخ النهاية",
        "category": "الفئة",
        "limit": "حد الميزانية"
      },
      "validation": {
        "limitValid": "أدخل حد ميزانية صحيحًا"
      }
    }
  },
  "expenses": {
    "title": "المصاريف",
    "empty": {
      "title": "أضف أول مصروف",
      "button": "إضافة مصروف"
    },
    "details": {
      "title": "تفاصيل المصروف",
      "fields": {
        "title": "العنوان",
        "category": "الفئة",
        "amount": "المبلغ",
        "date": "التاريخ",
        "note": "ملاحظة",
        "timeline": "الجدول الزمني"
      }
    },
    "form": {
      "title": {
        "add": "إضافة مصروف",
        "addButton": "إضافة مصروف",
        "edit": "تعديل مصروف",
        "editButton": "تعديل مصروف"
      },
      "fields": {
        "title": "العنوان",
        "titlePlaceholder": "البقالة",
        "amount": "المبلغ",
        "amountPlaceholder": "24.99",
        "date": "التاريخ",
        "category": "الفئة",
        "note": "ملاحظة",
        "notePlaceholder": "تفاصيل اختيارية",
        "currency": "العملة"
      },
      "validation": {
        "titleRequired": "العنوان مطلوب",
        "amountRequired": "المبلغ مطلوب",
        "amountValid": "يرجى إدخال مبلغ صحيح",
        "dateRequired": "التاريخ مطلوب",
        "categoryRequired": "يرجى اختيار فئة"
      }
    },
    "filters": {
      "title": "الفلاتر",
      "categories": {
        "all": "جميع الفئات"
      },
      "amountRange": "نطاق المبلغ",
      "searchHint": "ابحث عن المصاريف بالعنوان",
      "minimumAmount": "الحد الأدنى للمبلغ",
      "maximumAmount": "الحد الأعلى للمبلغ",
      "actions": {
        "apply": "تطبيق",
        "clear": "مسح الفلاتر",
        "cancel": "إلغاء"
      }
    },
    "item": {
      "actions": {
        "edit": "تعديل",
        "delete": "حذف"
      }
    },
    "management": {
      "delete": {
        "title": "حذف المصروف",
        "cancel": "إلغاء",
        "confirm": "حذف"
      }
    }
  },
  "categories": {
    "title": "الفئات",
    "details": {
      "title": "تفاصيل الفئة"
    },
    "list": {
      "delete": {
        "title": "حذف الفئة",
        "cancel": "إلغاء",
        "confirm": "حذف"
      },
      "tooltips": {
        "add": "إضافة فئة"
      }
    },
    "form": {
      "title": {
        "add": "إضافة فئة",
        "addButton": "إضافة فئة",
        "edit": "تعديل فئة",
        "editButton": "تعديل فئة"
      },
      "fields": {
        "name": "أدخل اسم الفئة"
      }
    },
    "item": {
      "stats": "{count} مصروفات",
      "actions": {
        "edit": "تعديل",
        "delete": "حذف"
      },
      "tooltips": {
        "actions": "إجراءات الفئة"
      }
    }
  },
  "dashboard": {
    "title": "الرئيسية",
    "empty": {
      "title": "أضف أول مصروف"
    },
    "error": {
      "retry": "إعادة المحاولة"
    },
    "chart": {
      "labelFormat": "{label}: ",
      "section": {
        "weeklySpending": "الإنفاق الأسبوعي",
        "weeklySubtitle": "وتيرة إنفاقك خلال هذا الأسبوع",
        "noData": {
          "title": "لا توجد بيانات أسبوعية",
          "message": "سيظهر مخطط الإنفاق الأسبوعي عند وجود نشاط هذا الأسبوع."
        }
      }
    }
  },
  "recurring": {
    "title": "المتكررة",
    "empty": {
      "title": "أضف مصروفًا متكررًا"
    },
    "details": {
      "nextDueDate": "تاريخ الاستحقاق التالي"
    },
    "item": {
      "actions": {
        "edit": "تعديل",
        "delete": "حذف"
      }
    },
    "form": {
      "title": {
        "add": "إضافة مصروف متكرر",
        "edit": "تعديل مصروف متكرر"
      },
      "fields": {
        "title": "العنوان",
        "amount": "المبلغ",
        "frequency": "التكرار",
        "startDate": "تاريخ البداية",
        "endDate": "تاريخ النهاية",
        "category": "الفئة"
      },
      "frequencies": {
        "daily": "يومي",
        "weekly": "أسبوعي",
        "biweekly": "كل أسبوعين",
        "monthly": "شهري",
        "quarterly": "ربع سنوي",
        "yearly": "سنوي"
      },
      "repeat": "التكرار"
    },
    "management": {
      "delete": {
        "title": "حذف المصروف المتكرر",
        "cancel": "إلغاء",
        "confirm": "حذف"
      }
    }
  },
  "export": {
    "title": "تصدير",
    "dialog": {
      "title": "تصدير البيانات",
      "exporting": "جارٍ التصدير...",
      "fileNotFound": "تعذر العثور على الملف: {filePath}",
      "message": "اطّلع على هذا الملف المصدّر من Spend Wise!",
      "options": {
        "csv": {
          "title": "تصدير CSV",
          "subtitle": "تصدير المصاريف كملف CSV"
        },
        "summary": {
          "title": "تصدير الملخص",
          "subtitle": "تصدير ملخص لوحة التحكم"
        },
        "backup": {
          "title": "إنشاء نسخة احتياطية",
          "subtitle": "نسخ احتياطي لجميع بيانات التطبيق"
        }
      },
      "actions": {
        "close": "إغلاق",
        "share": "مشاركة",
        "tryAgain": "حاول مرة أخرى"
      }
    }
  }
};
static const Map<String,dynamic> _en = {
  "app": {
    "title": "Spend Wise",
    "about": "About",
    "settings": "Settings"
  },
  "navigation": {
    "dashboard": "Dashboard",
    "expenses": "Expenses",
    "recurring": "Recurring",
    "categories": "Categories",
    "budgets": "Budgets",
    "insights": "Insights",
    "export": "Export"
  },
  "common": {
    "loading": "Loading...",
    "error": "An error occurred",
    "success": "Success",
    "confirmation": "Are you sure?",
    "actions": {
      "save": "Save",
      "cancel": "Cancel",
      "delete": "Delete",
      "edit": "Edit",
      "close": "Close",
      "apply": "Apply",
      "reset": "Reset",
      "tryAgain": "Try again",
      "share": "Share"
    },
    "validation": {
      "required": "This field is required",
      "invalid": "Please enter a valid value",
      "minLength": "Must be at least {min} characters",
      "maxLength": "Must not exceed {max} characters"
    },
    "errors": {
      "loadBudgets": "Failed to load budgets.",
      "loadRecurringExpenses": "Failed to load recurring expenses.",
      "budgetActionFailed": "Budget action failed."
    }
  },
  "currency": {
    "selection": "Select currency",
    "names": {
      "USD": "US Dollar",
      "EUR": "Euro",
      "ILS": "Israeli Shekel",
      "JOD": "Jordanian Dinar",
      "SAR": "Saudi Riyal",
      "GBP": "British Pound"
    }
  },
  "settings": {
    "preferences": {
      "title": "Preferences",
      "currency": {
        "title": "Currency",
        "subtitle": "Set your default currency for transactions"
      },
      "language": {
        "title": "Language",
        "subtitle": "Change the app language"
      }
    },
    "languages": {
      "english": "English",
      "arabic": "Arabic",
      "englishNative": "English",
      "arabicNative": "العربية"
    }
  },
  "budgets": {
    "title": "Budgets",
    "empty": {
      "title": "No budgets yet",
      "subtitle": "Create a category budget to stay ahead of your spending this month.",
      "button": "Create budget"
    },
    "card": {
      "edit": "Edit",
      "delete": "Delete",
      "saveChanges": "Save changes",
      "createBudget": "Create budget",
      "of": "of"
    },
    "remaining": "remaining",
    "success": {
      "created": "Budget created successfully.",
      "updated": "Budget updated successfully.",
      "deleted": "Budget deleted successfully."
    },
    "form": {
      "title": {
        "create": "Create budget",
        "edit": "Edit budget"
      },
      "fields": {
        "name": "Name",
        "amount": "Amount",
        "period": "Period",
        "startDate": "Start date",
        "endDate": "End date",
        "category": "Category",
        "limit": "Budget limit"
      },
      "validation": {
        "limitValid": "Enter a valid budget limit"
      }
    }
  },
  "expenses": {
    "title": "Expenses",
    "empty": {
      "title": "Add your first expense",
      "button": "Add expense"
    },
    "details": {
      "title": "Expense details",
      "fields": {
        "title": "Title",
        "category": "Category",
        "amount": "Amount",
        "date": "Date",
        "note": "Note",
        "timeline": "Timeline"
      }
    },
    "form": {
      "title": {
        "add": "Add expense",
        "addButton": "Add Expense",
        "edit": "Edit expense",
        "editButton": "Edit Expense"
      },
      "fields": {
        "title": "Title",
        "titlePlaceholder": "Groceries",
        "amount": "Amount",
        "amountPlaceholder": "24.99",
        "date": "Date",
        "category": "Category",
        "note": "Note",
        "notePlaceholder": "Optional details",
        "currency": "Currency"
      },
      "validation": {
        "titleRequired": "Title is required",
        "amountRequired": "Amount is required",
        "amountValid": "Please enter a valid amount",
        "dateRequired": "Date is required",
        "categoryRequired": "Please select a category"
      }
    },
    "filters": {
      "title": "Filters",
      "categories": {
        "all": "All categories"
      },
      "amountRange": "Amount range",
      "searchHint": "Search expenses by title",
      "minimumAmount": "Minimum amount",
      "maximumAmount": "Maximum amount",
      "actions": {
        "apply": "Apply",
        "clear": "Clear filters",
        "cancel": "Cancel"
      }
    },
    "item": {
      "actions": {
        "edit": "Edit",
        "delete": "Delete"
      }
    },
    "management": {
      "delete": {
        "title": "Delete expense",
        "cancel": "Cancel",
        "confirm": "Delete"
      }
    }
  },
  "categories": {
    "title": "Categories",
    "details": {
      "title": "Category details"
    },
    "list": {
      "delete": {
        "title": "Delete category",
        "cancel": "Cancel",
        "confirm": "Delete"
      },
      "tooltips": {
        "add": "Add category"
      }
    },
    "form": {
      "title": {
        "add": "Add category",
        "addButton": "Add Category",
        "edit": "Edit category",
        "editButton": "Edit Category"
      },
      "fields": {
        "name": "Enter category name"
      }
    },
    "item": {
      "stats": "{count} expenses",
      "actions": {
        "edit": "Edit",
        "delete": "Delete"
      },
      "tooltips": {
        "actions": "Category actions"
      }
    }
  },
  "dashboard": {
    "title": "Dashboard",
    "empty": {
      "title": "Add your first expense"
    },
    "error": {
      "retry": "Retry"
    },
    "chart": {
      "labelFormat": "{label}: ",
      "section": {
        "weeklySpending": "Weekly spending",
        "weeklySubtitle": "Your spending pace across this week",
        "noData": {
          "title": "No weekly data",
          "message": "Your weekly spending chart will appear once this week has activity."
        }
      }
    }
  },
  "recurring": {
    "title": "Recurring",
    "empty": {
      "title": "Add recurring expense"
    },
    "details": {
      "nextDueDate": "Next due date"
    },
    "item": {
      "actions": {
        "edit": "Edit",
        "delete": "Delete"
      }
    },
    "form": {
      "title": {
        "add": "Add recurring expense",
        "edit": "Edit recurring expense"
      },
      "fields": {
        "title": "Title",
        "amount": "Amount",
        "frequency": "Frequency",
        "startDate": "Start date",
        "endDate": "End date",
        "category": "Category"
      },
      "frequencies": {
        "daily": "Daily",
        "weekly": "Weekly",
        "biweekly": "Bi-weekly",
        "monthly": "Monthly",
        "quarterly": "Quarterly",
        "yearly": "Yearly"
      },
      "repeat": "Repeat"
    },
    "management": {
      "delete": {
        "title": "Delete recurring expense",
        "cancel": "Cancel",
        "confirm": "Delete"
      }
    }
  },
  "export": {
    "title": "Export",
    "dialog": {
      "title": "Export data",
      "exporting": "Exporting...",
      "fileNotFound": "File not found: {filePath}",
      "message": "Check out this exported file from Spend Wise!",
      "options": {
        "csv": {
          "title": "CSV export",
          "subtitle": "Export expenses as CSV"
        },
        "summary": {
          "title": "Summary export",
          "subtitle": "Export dashboard summary"
        },
        "backup": {
          "title": "Create backup",
          "subtitle": "Back up all app data"
        }
      },
      "actions": {
        "close": "Close",
        "share": "Share",
        "tryAgain": "Try again"
      }
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}
