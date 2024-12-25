import 'package:retail_app/config/app_detail.dart';

class DatabaseDetails {
  static String databaseName = AppDetails.appName;
  static int dbVersion = 1;

  ///
  static String clientListTable = "ClientInfo";
  static String companyDBName = "DbName";
  static String companyName = "CompanyName";
  static String ledgerCode = "LedgerCode";
  static String auth = "Auth";
  static String post = "Post";
  static String initial = "Initial";
  static String startDate = "StartDate";
  static String endDate = "EndDate";
  static String companyAddress = "CompanyAddress";
  static String phoneNo = "PhoneNo";
  static String vatNo = "VatNo";
  static String email = "Email";
  static String aliasName = "AliasName";

  ///
  static String ledgerCreateTable = "LedgerCreateTable";
  static String groupName = "GroupName";
  static String dbName = "DbName";
  static String category = "Catagory";
  static String panNo = "PanNo";
  static String salesRate = "SalesRate";
  static String contactPerson = "ContactPerson";
  static String customerCode = "CustomerCode";
  static String mobileNo = "MobileNo";
  static String customerName = "CustomerName";

  static const String ledgerDetailTable = "LedgerReportTableInfo";
  static const String vendorBillReportTable = "VendorBillReportTable";
  static const String vno = "Vno";
  static const String date = "Date";
  static const String miti = "Miti";
  static const String dr = "Dr";
  static const String cr = "Cr";
  static const String source = "Source";
  static const String narration = "Narration";
  static const String remark = "Remarks";
  static const String total = "Total";
  static const String netTotalAmount = "netTotalAmount";


  static String productCreateTable = "ProductCreateTable";
  static String id = "Id";
  static String pCode = "PCode";
  static String pDesc = "PDesc";
  static String pShortName = "PShortName";
  static String grpName = "GroupName";
  static String subGrpName = "SubGroupName";
  static String group1 = "Group1";
  static String group2 = "Group2";
  static String unit = "Unit";
  static String buyRate = "BuyRate";
  static String mrp = "MRP";
  static String tradeRate = "TradeRate";
  static String discountPercent = "Discount Percentage";
  static String imageName = "Image Name";
  static String pImage = "PImage";
  static String imageFolderName = "Image Folder Name";
  static String offerDiscount = "Offer Discount";
  static String stockStatus = "StockStatus";
  static String stockQty = "StockQty";

  //
  static String orderProductTable = "OrderProductInfo";
  static String purchaseOrderProductTable = "PurchaseOrderProductInfo";
  static String tempOrderProductTable = "TempOrderProductInfo";

  static String tempPurchaseOrderProductTable = "TempPurchaseOrderProductInfo";
  static String salesReturnTable = "SalesReturnInfo";
  static String userCode = "UserCode";
  static String comment = "Comment";
  static String glCode = "GlCode";
  static String pName = "PName";
  static String qty = "Qty";
  static String rate = "Rate";
  static String totalAmount = "TotalAmt";
  static String sign1 = "Sign1";
  static String sign2 = "Sign2";
  static String sign3 = "Sign3";
  static String bSign1 = "BSign1";
  static String bSign2 = "BSign2";
  static String bSign3 = "BSign3";

  static String itemCode = "itemCode";
  static String totalAmt = "totalAmt";
  static String netTotalAmt = "netTotalAmt";
  static String exciseAmount = "exciseAmount";
  static String discountAmount = "discountAmount";
  static String discountRate = "discountRate";
  static String vatAmount = "vatAmount";
  static String vatRate = "vatRate";
  //static String exciseRate = "exciseRate";
  static String godownCode = "godownCode";
  static String salesImage = "SalesImage";
  static String imagePath = "ImagePath";
  static String outletCode =  "OutletCode";
  static String ptCodeVat =  "PtCodeVat";
  static String ptCodeDisc =  "PtCodeDisc";

  static String pTerm1Code =  "PTerm1Code";
  static String pTerm1Rate =  "PTerm1Rate";
  static String pTerm1Amount =  "PTerm1Amount";

  static String pTerm2Code =  "PTerm2Code";
  static String pTerm2Rate =  "PTerm2Rate";
  static String pTerm2Amount =  "PTerm2Amount";

  static String pTerm3Code =  "PTerm3Code";
  static String pTerm3Rate =  "PTerm3Rate";
  static String pTerm3Amount =  "PTerm3Amount";

  static String bTerm1 =  "BTerm1";
  static String bTerm1Rate =  "BTerm1Rate";
  static String bTerm1Amount =  "BTerm1Amount";

  static String bTerm2 =  "BTerm2";
  static String bTerm2Rate =  "BTerm2Rate";
  static String bTerm2Amount =  "BTerm2Amount";

  static String bTerm3 =  "BTerm3";
  static String bTerm3Rate =  "BTerm3Rate";
  static String bTerm3Amount =  "BTerm3Amount";







  static String  purchaseReportTable = "PurchaseReportTable";
  static String vNo = "VNo";
  static String  vDate ="VDate";
  static String vMiti ="VMiti";
  static String glDesc ="GlDesc";
  static String netAmt ="NetAmt";

  // Sales Bill Term Table
  static String  ledgerTable = "leggerTable";
  static String  salesBillTermTable = "SalesBillTermTable";
  static String  purchaseBillTermTable = "PurchaseBillTermTable";
  static String pTCode = "PTCode";
  static String  pTDesc ="PTDesc";
  static String basis ="Basis";
  static String type ="Type";
  static String pTRate ="PTRate";
  static String sign ="Sign";

  static String glCatagory ="GlCatagory";


  static String  salesReportTable = "SalesReportTable";
  static String billDate = "BillDate";
  static String  billNo ="BillNo";
  static String salesType ="SalesType";
  static String netAmount ="NetAmount";

  static String customerListTable = "CustomerListTable";
  static String vendorListTable = "VendorListTable";
  static String accountGroup = "AccountGroup";
  static String accountSubGroup = "AccountSubGroup";
  static String glShortName = "Glshortname";
  static String amount = "Amount";
  static String address = "Address";
  static String mobileno = "MobileNo";

  static String salesBillReportListTable = "SalesBillReportListTable";
  static String hVno = "HVno";
  static String hDate = "HDate";
  static String hMiti = "HMiti";
  static String hGlDesc = "HGlDesc";
  static String hGlCode = "HGlCode";
  static String hPanNo = "HPanNo";
  static String hMobileNo = "HMobileNo";
  static String hAgent = "HAgent";
  static String dSno = "DSno";
  static String dPDesc = "DPDesc";
  static String dQty = "DQty";
  static String dAltQty = "DAltQty";
  static String dLocalRate = "DLocalRate";
  static String dBasicAmt = "DBasicAmt";
  static String dTermAMt = "DTermAMt";
  static String dNetAmt = "DNetAmt";
  static String unitCode = "UnitCode";
  static String altUnitCode = "AltUnitCode";
  static String Address = "Address";
  static String hTermAMt = "HTermAMt";
  static String hBasicAMt = "HBasicAMt";
  static String hNetAmt = "HNetAmt";
  static String balanceAmt = "BalanceAmt";

  static String accountGroupListTable = "AccountGroupListTable";
  static String grpCode = "GrpCode";
  static String grpDesc = "GrpDesc";
  static String grpShortName = "GrpShortName";
  static String grpSchedule = "GrpSchedule";
  static String primaryGrp = "PrimaryGrp";













//"Voucher Number": "8",




}