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
    "about": "حول",
    "settings": "الإعدادات",
    "subTitle": "متتبع ذكي للمصروفات والاشتراكات"
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
    "displayHint": "تُحفَظ المبالغ بالدولار الأمريكي وتُحوَّل للعرض فقط.",
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
    "hero": {
      "title": "خصص التطبيق",
      "subtitle": "حدّث تفضيلاتك من مكان واحد"
    },
    "appearance": {
      "title": "المظهر",
      "themeMode": {
        "title": "وضع المظهر",
        "subtitle": "اختر وضع المظهر المفضل لديك",
        "light": "فاتح",
        "dark": "داكن",
        "system": "النظام"
      }
    },
    "preferences": {
      "title": "التفضيلات",
      "currency": {
        "title": "العملة",
        "subtitle": "حدد العملة الافتراضية لعرض المبالغ",
        "displayHint": "تُحفَظ المبالغ بالدولار الأمريكي وتُحوَّل للعرض فقط."
      },
      "language": {
        "title": "اللغة",
        "subtitle": "غيّر لغة التطبيق"
      }
    },
    "notifications": {
      "title": "الإشعارات",
      "push": {
        "subtitle": "استقبل التنبيهات والتذكيرات"
      },
      "backup": {
        "title": "النسخ الاحتياطي التلقائي",
        "subtitle": "أنشئ نسخة احتياطية لبياناتك تلقائيًا"
      }
    },
    "data": {
      "title": "البيانات والخصوصية",
      "reset": {
        "title": "إعادة ضبط جميع الإعدادات",
        "subtitle": "استعادة جميع الإعدادات إلى قيمها الافتراضية",
        "dialogTitle": "إعادة ضبط جميع الإعدادات؟",
        "dialogMessage": "سيؤدي هذا إلى إعادة جميع الإعدادات إلى قيمها الافتراضية."
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
        "selectCategory": "اختر الفئة",
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
        "edit": "تعديل مصروف"
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
    "errors": {
      "noCategory": "لا توجد فئات متاحة",
      "noCategoryDescription": "يرجى محاولة تحميل الفئات مرة أخرى.",
      "actionLabel": "اعادة المحاولة",
      "load": "فشل تحميل الفئات.",
      "create": "إنشاء فئة",
      "empty": "لا توجد فئات بعد.",
      "emptyDescription": "اضغط على زر + لإنشاء أول فئة لك.",
      "emptyActionLabel": "إنشاء فئة"
    },
    "details": {
      "title": "تفاصيل الفئة",
      "totalSpent": "إجمالي المصروفات",
      "error": "فشل تحميل مصروفات الفئة",
      "titleEmpty": "لا توجد مصروفات في هذه الفئة حتى الآن",
      "subtitleEmpty": "بمجرد تعيين مصروفات لهذه الفئة، ستظهر هنا."
    },
    "list": {
      "spent": "أنفقت",
      "delete": {
        "title": "حذف الفئة",
        "subtitle": "هل أنت متأكد من رغبتك في حذف",
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
        "edit": "تعديل فئة"
      },
      "newCategory": "فئة جديدة",
      "fields": {
        "categoryName": "اسم الفئة",
        "name": "أدخل اسم الفئة",
        "emptyName": "اسم الفئة مطلوب",
        "nameLength": "يجب أن لا يتجاوز اسم الفئة 30 حرف",
        "selectColor": "اختر اللون",
        "selectIcon": "اختر الأيقونة",
        "saving": "جار الحفظ ..."
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
    },
    "deleting": "جار حذف الفئة...",
    "default": "افتراضي",
    "defaultCategories": {
      "food": "طعام ومأكولات",
      "transportation": "المواصلات",
      "utilities": "الفواتير",
      "entertainment": "الترفيه",
      "health": "الصحة واللياقة",
      "shopping": "التسوق"
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
      "title": "لا توجد مصاريف متكررة",
      "description": "تتبع الاشتراكات والفواتير المتكررة بحيث يتم إنشاء المصاريف المستحقة تلقائيًا.",
      "addBtn": "أضف مصروفًا متكررًا"
    },
    "details": {
      "nextDueDate": "تاريخ الاستحقاق التالي"
    },
    "form": {
      "title": {
        "add": "إضافة مصروف متكرر",
        "edit": "تعديل مصروف متكرر"
      },
      "validation": {
        "enterTitle": "أدخل عنوان",
        "enterAmount": "أدخل مبلغ صحيح"
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
        "monthly": "شهري",
        "yearly": "سنوي"
      },
      "save": "حفظ المصروف المتكرر",
      "create": "إنشاء مصروف متكرر",
      "repeat": "التكرار"
    },
    "successMessage": {
      "create": "تم إنشاء مصروف متكرر بنجاح.",
      "update": "تم تحديث المصروف المتكرر بنجاح.",
      "delete": "تم حذف المصروف المتكرر بنجاح."
    },
    "errorMessage": {
      "failedAction": "فشل إجراء المصروف المتكرر.",
      "failedLoad": "فشل تحميل المصروفات المتكررة."
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
    "about": "About",
    "settings": "Settings",
    "subTitle": "Smart Expense & Subscription Tracker"
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
    "displayHint": "Amounts stay stored in USD and are converted only for display.",
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
    "hero": {
      "title": "Personalize The App",
      "subtitle": "Update your preferences in one place"
    },
    "appearance": {
      "title": "Appearance",
      "themeMode": {
        "title": "Theme mode",
        "subtitle": "Choose Your Theme",
        "light": "Light",
        "dark": "Dark",
        "system": "System"
      }
    },
    "preferences": {
      "title": "Preferences",
      "currency": {
        "title": "Currency",
        "subtitle": "Set your default currency for transactions",
        "displayHint": "Amounts stay stored in USD and are converted only for display."
      },
      "language": {
        "title": "Language",
        "subtitle": "Change the app language"
      }
    },
    "notifications": {
      "title": "Notifications",
      "push": {
        "subtitle": "Receive alerts and reminders"
      },
      "backup": {
        "title": "Auto backup",
        "subtitle": "Automatically back up your data"
      }
    },
    "data": {
      "title": "Data & privacy",
      "reset": {
        "title": "Reset all settings",
        "subtitle": "Restore all settings to default values",
        "dialogTitle": "Reset all settings?",
        "dialogMessage": "This will reset all settings to their default values."
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
        "selectCategory": "Select Category",
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
    "errors": {
      "noCategory": "No categories available",
      "noCategoryDescription": "Please try loading your categories again.",
      "actionLabel": "Retry",
      "load": "Failed to load categories.",
      "create": "Create category",
      "empty": "No categories yet.",
      "emptyDescription": "Tap the + button to create your first category.",
      "emptyActionLabel": "Create category"
    },
    "details": {
      "title": "Category details",
      "totalSpent": "Total Spent",
      "error": "Could not load category expenses",
      "titleEmpty": "No expenses in this category yet",
      "subtitleEmpty": "Once you assign expenses to this category, they will appear here."
    },
    "list": {
      "spent": "Spent",
      "delete": {
        "title": "Delete category",
        "subtitle": "Are you sure you want to delete",
        "cancel": "Cancel",
        "confirm": "Delete"
      },
      "tooltips": {
        "add": "Add category"
      }
    },
    "form": {
      "title": {
        "add": "Add Category",
        "edit": "Edit Category"
      },
      "newCategory": "New Category",
      "fields": {
        "categoryName": "Category Name",
        "name": "Enter category name",
        "emptyName": "Category name is required",
        "nameLength": "Category name cannot be longer than 30 characters",
        "selectColor": "Select Color",
        "selectIcon": "Select Icon",
        "saving": "Saving ..."
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
    },
    "deleting": "Deleting category...",
    "default": "Default",
    "defaultCategories": {
      "food": "Food & Dining",
      "transportation": "Transportation",
      "utilities": "Utilities",
      "entertainment": "Entertainment",
      "health": "Health & Fitness",
      "shopping": "Shopping"
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
      "title": "No recurring expenses",
      "description": "Track subscriptions and repeating bills so due expenses are generated automatically.",
      "addBtn": "Add recurring expense"
    },
    "details": {
      "nextDueDate": "Next due date"
    },
    "form": {
      "title": {
        "add": "Add recurring expense",
        "edit": "Edit recurring expense"
      },
      "validation": {
        "enterTitle": "Enter a title",
        "enterAmount": "Enter a valid amount"
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
        "monthly": "Monthly",
        "yearly": "Yearly"
      },
      "save": "Save recurring expense",
      "create": "Create recurring expense",
      "repeat": "Repeat"
    },
    "successMessage": {
      "create": "Recurring expense created successfully.",
      "update": "Recurring expense updated successfully.",
      "delete": "Recurring expense deleted successfully."
    },
    "errorMessage": {
      "failedAction": "Recurring action failed.",
      "failedLoad": "Failed to load recurring expenses."
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
