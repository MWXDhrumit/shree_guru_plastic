import 'dart:typed_data';
import 'package:billing_app/model/company_details.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

import '../hive/customer_details_controller.dart';
import '../model/customer_details.dart';

class PDFGenerator {
  List<Invoice> invoiceData = [];
  List productData = [];



  Future<Uint8List> generatePdf(Invoice selectedInvoice) async {
    final pdf = pw.Document();

      var box = await Hive.openBox<CompanyDetailsModel>("democompany");
      List<CompanyDetailsModel> list = await box.values.toList();

    invoiceData= await CustomerDetailsController.getData();
    productData = invoiceData[0].products;
    print("dhrumit ${invoiceData[0].customerAddress}");
    print("harsh ${productData[0].amount}");


    List<Product> products = selectedInvoice.products;

    double subTotal = products.fold(0.0, (sum, item) => sum + item.amount);
    double cgst = selectedInvoice.cgst;
    double sgst = selectedInvoice.sgst;
    double grandTotal = selectedInvoice.grandTotal;

    invoiceData = [selectedInvoice]; // instead of getting all data
    productData = selectedInvoice.products;

    // Load the logo
    final Uint8List logoBytes = (await rootBundle.load('assets/sgp_logo.png')).buffer.asUint8List();
    final Uint8List signBytes = (await rootBundle.load('assets/sign.png')).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
            ),
            padding: pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // Header with Logo & Business Name
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo on the left
                    pw.Container(
                      width: 100,
                      height: 60,
                      child: pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.cover),
                    ),
                    // Business Name on the right
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(list[0].name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)), //company name
                        pw.Text(list[0].address, style: pw.TextStyle(fontSize: 10)), //company address
                        pw.Text(list[0].mobileNumber, style: pw.TextStyle(fontSize: 10)), //company phone number
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Divider(thickness: 1),

                // Invoice Info
                pw.Padding(
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(selectedInvoice.paymentType, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //cash/dabit
                      pw.Text(list[0].gstNumber, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //invoice number
                    ],
                  ),
                ),
                pw.Divider(thickness: 1),

                // Customer & Bill Details Box
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Name & Address", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //customer
                              pw.Text("Customer Name : ${selectedInvoice.customerName}", style: pw.TextStyle(fontSize: 9)), //customer name
                              pw.Text("Customer Address : ${selectedInvoice.customerAddress}", style: pw.TextStyle(fontSize: 9)), //customer address
                              pw.Text("Customer Mobile : ${selectedInvoice.customerPhone}", style: pw.TextStyle(fontSize: 9)), //customer phone number
                              pw.Text("Customer GST : ${selectedInvoice.customerGSTIN}", style: pw.TextStyle(fontSize: 9)), //customer gst
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(selectedInvoice.invoiceNumber, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //bill number
                              pw.Text(selectedInvoice.invoiceDate)
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),

                pw.SizedBox(height: 5),
                pw.Divider(thickness: 1),

                // Product Table Box
                // Product Table with 10 Rows and Increased Row Height
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
                  child: pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: pw.FlexColumnWidth(1),
                      1: pw.FlexColumnWidth(3),
                      2: pw.FlexColumnWidth(2),
                      3: pw.FlexColumnWidth(1),
                      4: pw.FlexColumnWidth(2),
                      5: pw.FlexColumnWidth(1),
                      6: pw.FlexColumnWidth(2),
                    },
                    children: [
                      // Table Header
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          _cell("SrNo"),
                          _cell("Product Name"),
                          _cell("HSN/SAC"),
                          _cell("Qty"),
                          _cell("Rate"),
                          _cell("Amount"),
                        ],
                      ),

                      // Product Rows (Always 10 Rows)
                      ...List.generate(10, (index) {
                        final item = index < products.length ? products[index] : null;
                        return pw.TableRow(
                          children: [
                            pw.Padding(child: pw.Text(index < products.length ? (index + 1).toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].productName : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].hsnCode : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].quantity.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].rate.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].amount.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                pw.SizedBox(height: 5),
                pw.Divider(thickness: 1),

                // Bank Details & Totals with Vertical Line
                pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Row(
                    children: [
                      // Bank Details Section
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Bank Details:", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Bank Name : ${list[0].bankName}", style: pw.TextStyle(fontSize: 9)), //bank name
                            pw.Text("Bank Account Number : ${list[0].accountNo}", style: pw.TextStyle(fontSize: 9)), //account number
                            pw.Text("Bank IFSC : ${list[0].ifsc}", style: pw.TextStyle(fontSize: 9)), //ifsc
                          ],
                        ),
                      ),

                      // Vertical Line
                      pw.Container(
                        width: 1,
                        height: 80,
                        color: PdfColors.black,
                      ),

                      // Total Amount Section
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("Sub Total: ${subTotal.toStringAsFixed(2)}",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            pw.Text("CGST 9%: ${(cgst).toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
                            pw.Text("SGST 9%: ${(sgst).toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10)),
                            pw.Divider(),
                            pw.Text("Grand Total:  ${grandTotal.toStringAsFixed(2)}",
                                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Divider(thickness: 1),

                // Terms & Conditions
                pw.Text("Terms & Conditions:", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.Text("1. Goods once sold will not be taken back.", style: pw.TextStyle(fontSize: 9)),
                pw.Text("2. Interest @18% p.a. will be charged if payment is not made within due date.", style: pw.TextStyle(fontSize: 9)),
                pw.Text("3. Our risk and responsibility ceases as soon as the goods leave our premises.", style: pw.TextStyle(fontSize: 9)),
                pw.Text("4. 'Subject to RAJKOT Jurisdiction only. E.&O.E'", style: pw.TextStyle(fontSize: 9)),

                pw.SizedBox(height: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end, // Align to the right
                  children: [
                    pw.Container(
                      width: context.page.pageFormat.availableWidth * 0.3, // 25% of page width
                      height: context.page.pageFormat.availableHeight * 0.08, // 8% of page height
                      child: pw.Image(pw.MemoryImage(signBytes), fit: pw.BoxFit.fill),
                    ),
                    pw.SizedBox(height: 5), // Small spacing between signature and text
                    pw.Text(
                      "For, SHRI GURU PLASTIC\n(Authorised Signatory)", //company name
                      style: pw.TextStyle(fontSize: context.page.pageFormat.availableWidth * 0.015, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right, // Right-aligned text
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
  pw.Widget _cell(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(6),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 10)),
    );
  }
}
class PrintPdf {
  void printInvoice(BuildContext context, Invoice invoice) async {
    final pdfData = await PDFGenerator().generatePdf(invoice);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }
}



class Product_invoice {
  final String name;
  final String hsnSac;
  final int qty;
  final double rate;
  final double gst;
  final double amount;

  Product_invoice({
    required this.name,
    required this.hsnSac,
    required this.qty,
    required this.rate,
    required this.gst,
    required this.amount,
  });
}
