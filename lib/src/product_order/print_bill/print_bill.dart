import 'package:flutter/material.dart';

import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../sales/model/product_sales_model.dart';

class SunmiPrinterService {
  Future<void> initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
  }

  Future<void> printText(String text,SunmiPrintAlign g) async {
   // await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      text,
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: true,
        align: g,
      ),
    );
  //  await SunmiPrinter.lineWrap(1);
  }

  Future<void> printTextBottom(String text,SunmiPrintAlign g) async {
    // await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      text,
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        bold: true,
        align: g,
      ),
    );
      await SunmiPrinter.lineWrap(1);
  }
  Future<void> printTextAddress(String text,SunmiPrintAlign g) async {
    await SunmiPrinter.printText(
      text,
      style: SunmiStyle(
        fontSize: SunmiFontSize.XS,
        bold: true,
        align: g,
      ),
    );
      await SunmiPrinter.lineWrap(1);
  }

  Future<void> closePrinter() async {
    await SunmiPrinter.unbindingPrinter();
  }

  Future<void> printProductOrder(
    List<ProductOrderModel> orderList,
    String voucherNo,
    String customerName,
    String companyName,
    String companyAddress,
  ) async {
    try {
      await initialize();

      await _printHeader(companyName, customerName, voucherNo,companyAddress);

      await _printOrderDetails(orderList);

      await _printFooter();

      await closePrinter();
    } catch (e) {
      debugPrint('Error printing order: $e');
      await closePrinter();
      rethrow;
    }
  }

  Future<void> _printHeader(
    String companyName,
    String customerName,
    String voucherNo,
    String companyAddress,
  ) async {
    await printText(companyName,SunmiPrintAlign.CENTER);
    await printTextAddress(companyAddress,SunmiPrintAlign.CENTER);
   // await printText('address : ${companyAddress}',SunmiPrintAlign.CENTER);
    //await printText(companyAddress);


    await SunmiPrinter.printText(
      "Customer: $customerName",
      style: SunmiStyle(
        fontSize: SunmiFontSize.SM,
        bold: true,
      ),
    );

    String currentDate = DateTime.now().toString().split('.')[0];
    await SunmiPrinter.printText(
      "Order No: $voucherNo",
      style: SunmiStyle(
        fontSize: SunmiFontSize.SM,
        align: SunmiPrintAlign.LEFT,
        bold: true,
      ),
    );
    await SunmiPrinter.printText(
      "Date: $currentDate",
      style: SunmiStyle(
        fontSize: SunmiFontSize.SM,
        align: SunmiPrintAlign.LEFT,
        bold: true,
      ),
    );
    await SunmiPrinter.lineWrap(1);

    await _printColumnHeaders();
  }

  Future<void> _printColumnHeaders() async {
    await SunmiPrinter.setFontSize(SunmiFontSize.SM);
    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Sno.",
        width: 4,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Item",
        width: 15,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Qty",
        width: 4,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: "Rate",
        width: 8,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: "Total",
        width: 9,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);

    await _printSeparator();
  }

  Future<void> _printSeparator() async {
    await SunmiPrinter.printText(
      "-----------------------------------------",
      style: SunmiStyle(align: SunmiPrintAlign.CENTER),
    );
  }

  Future<void> _printOrderDetails(List<ProductOrderModel> orderList) async {
    await SunmiPrinter.bold();
    double grandTotal = 0.0;

    int i=0;
    for (var item in orderList) {
      i++;
      await SunmiPrinter.setFontSize(SunmiFontSize.SM);
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: '${i.toString()}.',
          width: 4,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: item.pName,
          width: 15,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: item.qty,
          width: 4,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: item.rate,
          width: 8,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: (double.parse(item.totalAmt) * double.parse(item.qty)).toStringAsFixed(2),
          width: 9,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      grandTotal += (double.parse(item.totalAmt) * double.parse(item.qty));
      await SunmiPrinter.lineWrap(0);

    }

    await _printGrandTotal(grandTotal);
  }

  Future<void> _printGrandTotal(double grandTotal) async {
    await _printSeparator();

    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: "Grand Total:",
        width: 20,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: grandTotal.toStringAsFixed(2),
        width: 10,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
  }

  Future<void> _printFooter() async {
    await SunmiPrinter.lineWrap(1);
    await printTextBottom("Thank You For Your Business!",SunmiPrintAlign.CENTER);
    await SunmiPrinter.lineWrap(2);
  }
}
