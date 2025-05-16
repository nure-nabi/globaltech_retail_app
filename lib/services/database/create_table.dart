import 'package:sqflite/sqflite.dart';
import 'database_const.dart';

class CreateTable {
  Database db;
  CreateTable(this.db);

  /// Company List Info
  companyListTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseDetails.clientListTable} (
        ${DatabaseDetails.companyDBName} TEXT,
        ${DatabaseDetails.companyName} TEXT,
        ${DatabaseDetails.ledgerCode} TEXT,
        ${DatabaseDetails.auth} TEXT,
        ${DatabaseDetails.post} TEXT,
        ${DatabaseDetails.initial} TEXT,
        ${DatabaseDetails.startDate} TEXT,
        ${DatabaseDetails.endDate} TEXT,
        ${DatabaseDetails.companyAddress} TEXT,
        ${DatabaseDetails.phoneNo} TEXT,
        ${DatabaseDetails.vatNo} TEXT,
        ${DatabaseDetails.email} TEXT,
        ${DatabaseDetails.aliasName} TEXT
      )
    ''');
  }

  ledgerCreateTable() async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${DatabaseDetails.ledgerCreateTable} (
      ${DatabaseDetails.pCode} TEXT,
      ${DatabaseDetails.dbName} TEXT,
      ${DatabaseDetails.category} TEXT,
      ${DatabaseDetails.panNo} TEXT,
      ${DatabaseDetails.contactPerson} TEXT,
      ${DatabaseDetails.salesRate} TEXT,
      ${DatabaseDetails.customerCode} TEXT,
      ${DatabaseDetails.mobileNo} TEXT,
      ${DatabaseDetails.email} TEXT,
      ${DatabaseDetails.customerName} TEXT
    )
  ''');
  }

  ledgerReportTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.ledgerDetailTable} (
                                                ${DatabaseDetails.glCode} TEXT,
                                                ${DatabaseDetails.vno} TEXT,
                                                ${DatabaseDetails.date} TEXT,
                                                ${DatabaseDetails.miti} TEXT,
                                                ${DatabaseDetails.source} TEXT,
                                                ${DatabaseDetails.dr} TEXT,
                                                ${DatabaseDetails.cr} TEXT,
                                                ${DatabaseDetails.netTotalAmount} TEXT,
                                                ${DatabaseDetails.remark} TEXT,
                                                ${DatabaseDetails.narration} TEXT,
                                                ${DatabaseDetails.total} TEXT) ''');
  }
  vendorBillReportTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.vendorBillReportTable} (
                                                ${DatabaseDetails.glCode} TEXT,
                                                ${DatabaseDetails.vno} TEXT,
                                                ${DatabaseDetails.date} TEXT,
                                                ${DatabaseDetails.miti} TEXT,
                                                ${DatabaseDetails.source} TEXT,
                                                ${DatabaseDetails.dr} TEXT,
                                                ${DatabaseDetails.cr} TEXT,
                                                ${DatabaseDetails.netTotalAmount} TEXT,
                                                ${DatabaseDetails.remark} TEXT,
                                                ${DatabaseDetails.narration} TEXT,
                                                ${DatabaseDetails.total} TEXT) ''');
  }

  productCreateTable() async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${DatabaseDetails.productCreateTable} (
      ${DatabaseDetails.pCode} TEXT,      
                                                ${DatabaseDetails.pDesc} TEXT,      
                                                ${DatabaseDetails.pShortName} TEXT,      
                                                ${DatabaseDetails.grpName} TEXT,      
                                                ${DatabaseDetails.subGrpName} TEXT,      
                                                ${DatabaseDetails.group1} TEXT,      
                                                ${DatabaseDetails.group2} TEXT,      
                                                ${DatabaseDetails.unit} TEXT,
                                                ${DatabaseDetails.altUnit} TEXT,
                                                ${DatabaseDetails.altQty} TEXT,
                                                ${DatabaseDetails.hsCode} TEXT,
                                                ${DatabaseDetails.buyRate} TEXT,
                                                ${DatabaseDetails.salesRate} TEXT,
                                                ${DatabaseDetails.mrp} TEXT,
                                                ${DatabaseDetails.tradeRate} TEXT,
                                                [${DatabaseDetails.discountPercent}] TEXT,
                                                [${DatabaseDetails.imageName}] TEXT,
                                                ${DatabaseDetails.pImage} TEXT,
                                                [${DatabaseDetails.imageFolderName}] TEXT,
                                                [${DatabaseDetails.offerDiscount}] TEXT,
                                                ${DatabaseDetails.stockStatus} TEXT,
                                                ${DatabaseDetails.stockQty} TEXT
   )
  ''');
  }

  /// Temp Order Product Info
  tempOrderProductTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.tempOrderProductTable} (  
                                                ${DatabaseDetails.id} INTEGER PRIMARY KEY AUTOINCREMENT,     
                                                ${DatabaseDetails.pCode} TEXT, 
                                                ${DatabaseDetails.pShortName} TEXT,    
                                                ${DatabaseDetails.pName} TEXT,     
                                                ${DatabaseDetails.qty} TEXT,      
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.pTerm1Code} TEXT,
                                                ${DatabaseDetails.pTerm1Rate} TEXT,
                                                ${DatabaseDetails.pTerm1Amount} TEXT,
                                                ${DatabaseDetails.sign1} TEXT,
                                                ${DatabaseDetails.pTerm2Code} TEXT,
                                                ${DatabaseDetails.pTerm2Rate} TEXT,
                                                ${DatabaseDetails.pTerm2Amount} TEXT,
                                                ${DatabaseDetails.sign2} TEXT,
                                                 ${DatabaseDetails.pTerm3Code} TEXT,
                                                ${DatabaseDetails.pTerm3Rate} TEXT,
                                                ${DatabaseDetails.pTerm3Amount} TEXT,
                                                ${DatabaseDetails.sign3} TEXT,
                                                ${DatabaseDetails.totalAmount} TEXT,
                                                ${DatabaseDetails.unit} TEXT,
                                                ${DatabaseDetails.altUnit} TEXT,
                                                ${DatabaseDetails.altQty} TEXT,
                                                ${DatabaseDetails.hsCode} TEXT,
                                                 ${DatabaseDetails.factor} TEXT
                                          ) ''');
  }
  /// Order Product Info
  orderProductTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.orderProductTable} (  
                                                ${DatabaseDetails.itemCode} TEXT,     
                                                ${DatabaseDetails.pName} TEXT,     
                                                ${DatabaseDetails.qty} TEXT,      
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.totalAmt} TEXT,
                                                ${DatabaseDetails.netTotalAmt} TEXT,
                                                ${DatabaseDetails.pTerm1Code} TEXT,
                                                ${DatabaseDetails.pTerm1Rate} TEXT,
                                                ${DatabaseDetails.pTerm1Amount} TEXT,
                                                 ${DatabaseDetails.sign1} TEXT,
                                                ${DatabaseDetails.pTerm2Code} TEXT,
                                                ${DatabaseDetails.pTerm2Rate} TEXT,
                                                ${DatabaseDetails.pTerm2Amount} TEXT,
                                                 ${DatabaseDetails.sign2} TEXT,
                                                 ${DatabaseDetails.pTerm3Code} TEXT,
                                                ${DatabaseDetails.pTerm3Rate} TEXT,
                                                ${DatabaseDetails.pTerm3Amount} TEXT,
                                                 ${DatabaseDetails.sign3} TEXT,
                                                ${DatabaseDetails.bTerm1} TEXT,
                                                ${DatabaseDetails.bTerm1Rate} TEXT,
                                                ${DatabaseDetails.bTerm1Amount} TEXT,
                                                ${DatabaseDetails.bSign1} TEXT,
                                                ${DatabaseDetails.bTerm2} TEXT,
                                                ${DatabaseDetails.bTerm2Rate} TEXT,
                                                ${DatabaseDetails.bTerm2Amount} TEXT,
                                                ${DatabaseDetails.bSign2} TEXT,
                                                ${DatabaseDetails.bTerm3} TEXT,
                                                ${DatabaseDetails.bTerm3Rate} TEXT,
                                                ${DatabaseDetails.bTerm3Amount} TEXT,
                                                ${DatabaseDetails.bSign3} TEXT,
                                                ${DatabaseDetails.godownCode} TEXT,
                                                ${DatabaseDetails.dbName} TEXT,
                                                ${DatabaseDetails.salesImage} TEXT,
                                                ${DatabaseDetails.imagePath} TEXT,
                                                ${DatabaseDetails.outletCode} TEXT,
                                                 ${DatabaseDetails.unit} TEXT,
                                                ${DatabaseDetails.altUnit} TEXT,
                                                ${DatabaseDetails.altQty} TEXT,
                                                ${DatabaseDetails.hsCode} TEXT,
                                                ${DatabaseDetails.factor} TEXT,
                                                ${DatabaseDetails.userCode} TEXT,
                                                ${DatabaseDetails.billNetAmt} TEXT,
                                                ${DatabaseDetails.payAmount} TEXT,
                                                ${DatabaseDetails.paymentMode} TEXT
                                          ) ''');
  }
  /// Temp purchse Order Product Info
  temppurchaseOrderProductTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.tempPurchaseOrderProductTable} (  
                                                ${DatabaseDetails.id} INTEGER PRIMARY KEY AUTOINCREMENT,     
                                                ${DatabaseDetails.pCode} TEXT,     
                                                ${DatabaseDetails.pName} TEXT,     
                                                ${DatabaseDetails.qty} TEXT,      
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.pTerm1Code} TEXT,
                                                ${DatabaseDetails.pTerm1Rate} TEXT,
                                                ${DatabaseDetails.pTerm1Amount} TEXT,
                                                ${DatabaseDetails.sign1} TEXT,
                                                ${DatabaseDetails.pTerm2Code} TEXT,
                                                ${DatabaseDetails.pTerm2Rate} TEXT,
                                                ${DatabaseDetails.pTerm2Amount} TEXT,
                                                ${DatabaseDetails.sign2} TEXT,
                                                ${DatabaseDetails.pTerm3Code} TEXT,
                                                ${DatabaseDetails.pTerm3Rate} TEXT,
                                                ${DatabaseDetails.pTerm3Amount} TEXT,
                                                ${DatabaseDetails.sign3} TEXT,
                                                ${DatabaseDetails.totalAmount} TEXT,
                                                 ${DatabaseDetails.factor} TEXT
                                          ) ''');
  }
  /// Order Product Info
  purchaseOrderProductTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.purchaseOrderProductTable} (  
                                                ${DatabaseDetails.itemCode} TEXT,     
                                                ${DatabaseDetails.pName} TEXT,     
                                                ${DatabaseDetails.qty} TEXT,      
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.totalAmt} TEXT,
                                                ${DatabaseDetails.netTotalAmt} TEXT,
                                                ${DatabaseDetails.pTerm1Code} TEXT,
                                                ${DatabaseDetails.pTerm1Rate} TEXT,
                                                ${DatabaseDetails.pTerm1Amount} TEXT,
                                                ${DatabaseDetails.pTerm2Code} TEXT,
                                                ${DatabaseDetails.pTerm2Rate} TEXT,
                                                ${DatabaseDetails.pTerm2Amount} TEXT,
                                                ${DatabaseDetails.pTerm3Code} TEXT,
                                                ${DatabaseDetails.pTerm3Rate} TEXT,
                                                ${DatabaseDetails.pTerm3Amount} TEXT,
                                                ${DatabaseDetails.bTerm1} TEXT,
                                                ${DatabaseDetails.bTerm1Rate} TEXT,
                                                ${DatabaseDetails.bTerm1Amount} TEXT,
                                                ${DatabaseDetails.bSign1} TEXT,
                                                ${DatabaseDetails.bTerm2} TEXT,
                                                ${DatabaseDetails.bTerm2Rate} TEXT,
                                                ${DatabaseDetails.bTerm2Amount} TEXT,
                                                ${DatabaseDetails.bSign2} TEXT,
                                                
                                                ${DatabaseDetails.bTerm3} TEXT,
                                                ${DatabaseDetails.bTerm3Rate} TEXT,
                                                ${DatabaseDetails.bTerm3Amount} TEXT,
                                                ${DatabaseDetails.bSign3} TEXT,
                                                ${DatabaseDetails.godownCode} TEXT,
                                                ${DatabaseDetails.dbName} TEXT,
                                                ${DatabaseDetails.salesImage} TEXT,
                                                ${DatabaseDetails.imagePath} TEXT,
                                                ${DatabaseDetails.outletCode} TEXT,
                                                ${DatabaseDetails.unit} TEXT
                                          ) ''');
  }

  ///purchase report table
  purchaseReportTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.purchaseReportTable} (
                                                ${DatabaseDetails.vNo} TEXT,
                                                ${DatabaseDetails.vDate} TEXT,
                                                ${DatabaseDetails.vMiti} TEXT,
                                                ${DatabaseDetails.glDesc} TEXT,
                                                ${DatabaseDetails.netAmt} TEXT
                                              ) ''');
  }

  salesReportTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.salesReportTable} (
                                                ${DatabaseDetails.billDate} TEXT,
                                                ${DatabaseDetails.billNo} TEXT,
                                                ${DatabaseDetails.glDesc} TEXT,
                                                ${DatabaseDetails.salesType} TEXT,
                                                ${DatabaseDetails.netAmount} TEXT
                                              ) ''');
  }
  // Sale Term Table
  salesTermTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.salesBillTermTable} (
                                                ${DatabaseDetails.pTCode} TEXT,
                                                ${DatabaseDetails.pTDesc} TEXT,
                                                ${DatabaseDetails.basis} TEXT,
                                                ${DatabaseDetails.type} TEXT,
                                                ${DatabaseDetails.pTRate} TEXT,
                                                ${DatabaseDetails.sign} TEXT
                                              ) ''');
  }
  // Sale Term Table
  purchaseTermTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.purchaseBillTermTable} (
                                                ${DatabaseDetails.pTCode} TEXT,
                                                ${DatabaseDetails.pTDesc} TEXT,
                                                ${DatabaseDetails.basis} TEXT,
                                                ${DatabaseDetails.type} TEXT,
                                                ${DatabaseDetails.pTRate} TEXT,
                                                ${DatabaseDetails.sign} TEXT
                                              ) ''');
  }
  // Ledger
  ledgerTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.ledgerTable} (
                                                ${DatabaseDetails.glCode} TEXT,
                                                ${DatabaseDetails.glDesc} TEXT,
                                                ${DatabaseDetails.glCatagory} TEXT,
                                                ${DatabaseDetails.mobileNo} TEXT,
                                                ${DatabaseDetails.address} TEXT,
                                                ${DatabaseDetails.panNo} TEXT
                                               
                                              ) ''');
  }

  customerListTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseDetails.customerListTable} (
        ${DatabaseDetails.category} TEXT,
        ${DatabaseDetails.glDesc} TEXT,
        ${DatabaseDetails.glCode} TEXT,
        ${DatabaseDetails.accountGroup} TEXT,
        ${DatabaseDetails.accountSubGroup} TEXT,
        ${DatabaseDetails.glShortName} TEXT,
        ${DatabaseDetails.amount} TEXT,
        ${DatabaseDetails.address} TEXT,
        ${DatabaseDetails.mobileno} TEXT,
        ${DatabaseDetails.panNo} TEXT
      )
    ''');
  }

  vendorListTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseDetails.vendorListTable} (
        ${DatabaseDetails.category} TEXT,
        ${DatabaseDetails.glDesc} TEXT,
        ${DatabaseDetails.glCode} TEXT,
        ${DatabaseDetails.accountGroup} TEXT,
        ${DatabaseDetails.accountSubGroup} TEXT,
        ${DatabaseDetails.glShortName} TEXT,
        ${DatabaseDetails.amount} TEXT,
        ${DatabaseDetails.address} TEXT,
        ${DatabaseDetails.mobileno} TEXT,
        ${DatabaseDetails.panNo} TEXT
      )
    ''');
  }
  salesBillReportListTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseDetails.salesBillReportListTable} (
        ${DatabaseDetails.hVno} TEXT,
        ${DatabaseDetails.hDate} TEXT,
        ${DatabaseDetails.hMiti} TEXT,
        ${DatabaseDetails.hGlDesc} TEXT,
        ${DatabaseDetails.hGlCode} TEXT,
        ${DatabaseDetails.hPanNo} TEXT,
        ${DatabaseDetails.hMobileNo} TEXT,
        ${DatabaseDetails.hAgent} TEXT,
        ${DatabaseDetails.dSno} TEXT,
        ${DatabaseDetails.dPDesc} TEXT,
        ${DatabaseDetails.dQty} TEXT,
        ${DatabaseDetails.dAltQty} TEXT,
        ${DatabaseDetails.hPrintCopy} TEXT,
        ${DatabaseDetails.dLocalRate} TEXT,
        ${DatabaseDetails.dBasicAmt} TEXT,
        ${DatabaseDetails.dTermAMt} TEXT,
        ${DatabaseDetails.dNetAmt} TEXT,
        ${DatabaseDetails.unitCode} TEXT,
        ${DatabaseDetails.altUnitCode} TEXT,
        ${DatabaseDetails.Address} TEXT,
        ${DatabaseDetails.hTermAMt} TEXT,
        ${DatabaseDetails.hBasicAMt} TEXT,
        ${DatabaseDetails.hNetAmt} TEXT,
        ${DatabaseDetails.balanceAmt} TEXT
      )
    ''');
  }
  // Ledger
  accountGroupListTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.accountGroupListTable} (
                                                ${DatabaseDetails.grpCode} TEXT,
                                                ${DatabaseDetails.grpDesc} TEXT,
                                                ${DatabaseDetails.grpShortName} TEXT,
                                                ${DatabaseDetails.grpSchedule} TEXT,
                                                ${DatabaseDetails.primaryGrp} TEXT
                                               
                                              ) ''');
  }
  /// Order List Table
  orderListTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.orderListTable} (
                                                ${DatabaseDetails.orderId} INTEGER PRIMARY KEY AUTOINCREMENT,
                                                ${DatabaseDetails.id} TEXT,
                                                ${DatabaseDetails.productCode} TEXT,
                                                ${DatabaseDetails.productName} TEXT,
                                                ${DatabaseDetails.quantity} TEXT,
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.productDescription} TEXT,
                                                ${DatabaseDetails.total} TEXT,
                                                ${DatabaseDetails.images} TEXT
                                                ) ''');
  }
  /// Order Post Table
  orderPostTable() async {
    await db.execute(
        ''' CREATE TABLE if not exists ${DatabaseDetails.orderPostTable} (
                                                ${DatabaseDetails.dbName} TEXT,
                                                ${DatabaseDetails.glCode} TEXT,
                                                ${DatabaseDetails.userCode} TEXT,
                                                ${DatabaseDetails.pcode} TEXT,
                                                ${DatabaseDetails.rate} TEXT,
                                                ${DatabaseDetails.qty} TEXT,
                                                ${DatabaseDetails.totalAmt} TEXT,
                                                ${DatabaseDetails.comment} TEXT
                                                ) ''');
  }
}


