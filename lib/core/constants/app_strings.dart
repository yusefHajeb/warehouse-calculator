/// Arabic UI strings used across the application.
class AppStrings {
  AppStrings._();

  // ── General ──
  static const String appTitle = 'حاسبة المستودع';
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';

  // ── Add / Edit Product Screen ──
  static const String addEditProductTitle = 'إضافة/تعديل تفاصيل المنتج';
  static const String saveProduct = 'حفظ المنتج';

  // Section headers
  static const String basicInfoSection = 'المعلومات الأساسية';
  static const String packagingSection = 'مكونات الصنف ';
  static const String ingredientsSection = 'المكونات';

  // Basic info
  static const String productName = 'اسم الصنف';
  static const String productNameHint = 'مثال: كوكيز بالشوكولاتة';

  // Packaging
  static const String piecesPerBox = 'عدد القطع لكل علبة';
  static const String boxesPerCarton = 'عدد العلب لكل كرتونة';
  static const String packagingInfoNote =
      'سيتم حساب إجمالي القطع في الكرتونة تلقائيًا بناءً على هذه القيم.';

  // Ingredients
  static const String quantityPerPieceLabel = 'الكمية لكل قطعة (جرام)';
  static const String ingredientNameHint = 'اسم المكون';
  static const String weightHint = '0.0';
  static const String gramSymbol = 'ج';
  static const String addIngredient = 'إضافة مكون';

  // ── Manage Products Screen ──
  static const String productsTitle = 'المنتجات';
  static const String productsSubtitle = 'إدارة المخزون والتعبئة';
  static const String searchProductsHint = 'بحث عن المنتجات...';
  static const String edit = 'تعديل';
  static const String itemNumber = 'رقم الصنف';
  static const String lastUpdate = 'آخر تحديث';

  // Status badges
  static const String statusAvailable = 'متوفر';
  static const String statusLowStock = 'مخزون منخفض';
  static const String statusArchived = 'مؤرشف';

  // ── Bottom Navigation ──
  static const String navHome = 'الرئيسية';
  static const String navProducts = 'المنتجات';
  static const String navCalculator = 'الحاسبة';
  static const String navSettings = 'الإعدادات';
  static const String navHistory = 'السجل';
  static const String navReports = 'التقارير';

  // ── Home Screen ──
  static const String homeAppName = 'ProCalc';
  static const String homeAppNameSuffix = '.io';
  static const String homeAppSubtitle = 'عمليات المستودع';
  static const String homeGreeting = 'صباح الخير، عمار';
  static const String homeShiftInfo = 'الوردية أ • الطابق 3';
  static const String homeDateLabel = 'التاريخ';
  static const String homeDate = '24 أكتوبر، 2023';
  static const String homePendingOrders = 'طلبات معلقة';
  static const String homeProductivity = 'الإنتاجية';
  static const String homeAlerts = 'تنبيهات';
  static const String homeCalculateOrder = 'حساب الطلب';
  static const String homeCalculateOrderDesc = 'تحديد متطلبات المواد الخام لدفعات الإنتاج القادمة.';
  static const String homeStartCalculation = 'بدء الحساب';
  static const String homeManageProducts = 'إدارة المنتجات';
  static const String homeManageProductsDesc = 'تحديث المخزون، مسح الباركود، وإدارة قائمة الجرد.';
  static const String homeOpenInventory = 'فتح المخزون';
  static const String homeRecentActivity = 'تم حساب الطلب #402';
  static const String homeRecentActivityTime = 'منذ 10 دقائق • 150 وحدة';
  static const String homeView = 'عرض';
  static const String homeComingSoon = 'قريبًا...';

  // ── Calculate Order Screen ──
  static const String calcTitle = 'حساب طلب جديد';
  static const String calcReset = 'إعادة تعيين';
  static const String calcSelectProduct = 'اختر المنتج';
  static const String calcSearchHint = 'بحث برقم الصنف أو الاسم...';
  static const String calcRecentChoices = 'اختيارات حديثة';
  static const String calcCartonCount = 'عدد الكراتين';
  static const String calcCartonLabel = 'كرتون';
  static const String calcMinLabel = 'الحد الأدنى: ١٠';
  static const String calcMaxLabel = 'السعة القصوى: ٢٥٠٠';
  static const String calcInfoTitle = 'معاينة الحساب';
  static const String calcInfoBody =
      'بناءً على المخزون الحالي، سيتم حجز المواد الخام تلقائيًا عند الحساب.';
  static const String calcButton = 'احسب المتطلبات';

  // ── Calculation Results Screen ──
  static const String resultsTitle = 'ملخص النتائج';
  static const String resultsProductLabel = 'اسم المنتج';
  static const String resultsQuantityLabel = 'الكمية';
  static const String resultsCreationDate = 'تاريخ الإنشاء';
  static const String resultsTotalProduction = 'إجمالي الإنتاج المتوقع';
  static const String resultsTotalPieces = 'إجمالي القطع';
  static const String resultsPackSize = 'حجم العبوة';
  static const String resultsBatchNumber = 'رقم التشغيلة';
  static const String resultsRawMaterials = 'المواد الخام المطلوبة';
  static const String resultsEditInputs = 'تعديل المدخلات';
  static const String resultsIngredientCol = 'المكون';
  static const String resultsPerPieceCol = 'لكل قطعة (غ)';
  static const String resultsRequiredCol = 'الكمية المطلوبة (كجم)';
  static const String resultsTotalWeight = 'إجمالي الوزن';
  static const String resultsStockWarningTitle = 'تنبيه المخزون';
  static const String resultsExportPdf = 'تصدير PDF';
  static const String resultsPrint = 'طباعة';
}
