import 'dart:typed_data';
import 'package:billing_app/model/customer_details.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFGenerator {
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    List<Product> products = [
      Product(name: "Product 1", hsnSac: "1234", qty: 5, rate: 100, gst: 18, amount: 590),
      Product(name: "Product 2", hsnSac: "5678", qty: 3, rate: 200, gst: 12, amount: 672),
    ];

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
                        pw.Text("SHRI GURU PLASTIC", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)), //company name
                        pw.Text("F3, B ROAD, SHADE NO.3317 DARED, JAMNAGAR", style: pw.TextStyle(fontSize: 10)), //company address
                        pw.Text("Mo. 9924475849", style: pw.TextStyle(fontSize: 10)), //company phone number
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
                      pw.Text("Cash / Debit", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //cash/dabit
                      pw.Text("Invoice No.: GT/394", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //invoice number
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
                              pw.Text("SHRI GURU PLASTIC", style: pw.TextStyle(fontSize: 9)), //customer name
                              pw.Text("F3, B ROAD, SHADE NO.3317 DARED, JAMNAGAR", style: pw.TextStyle(fontSize: 9)), //customer address
                              pw.Text("9924475849", style: pw.TextStyle(fontSize: 9)), //customer phone number
                              pw.Text("Place of Supply: 24-Gujarat", style: pw.TextStyle(fontSize: 9)),
                              pw.Text("GSTIN No.: 24AMZPB4007H1Z5", style: pw.TextStyle(fontSize: 9)), //customer gst
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Bill No.: GT/394", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)), //bill number
                              pw.Text("Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}", style: pw.TextStyle(fontSize: 10)), //date
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
                          pw.Padding(child: pw.Text("SrNo", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("Product Name", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("HSN/SAC", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("Qty", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("Rate", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("GST %", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                          pw.Padding(child: pw.Text("Amount", style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)), padding: pw.EdgeInsets.all(8)),
                        ],
                      ),

                      // Product Rows (Always 10 Rows)
                      ...List.generate(10, (index) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(child: pw.Text(index < products.length ? (index + 1).toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].name : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].hsnSac : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].qty.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].rate.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].gst.toString() : "", style: pw.TextStyle(fontSize: 10)), padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
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
                            pw.Text("Bank Name: HDFC BANK", style: pw.TextStyle(fontSize: 9)), //bank name
                            pw.Text("Bank A/C No.: 5020029517620", style: pw.TextStyle(fontSize: 9)), //account number
                            pw.Text("RTGS/IFSC Code: HDFC0001659", style: pw.TextStyle(fontSize: 9)), //ifsc
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
                            pw.Text("Sub Total: 6750.00",
                                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Taxable Amount: 6750.00", style: pw.TextStyle(fontSize: 10)),
                            pw.Text("CGST 9%: 607.50", style: pw.TextStyle(fontSize: 10)),
                            pw.Text("SGST 9%: 607.50", style: pw.TextStyle(fontSize: 10)),
                            pw.Divider(),
                            pw.Text("Grand Total: 7,965.00",
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
}
class PrintPdf {
  void printPdf(BuildContext context) async {
    final pdfData = await PDFGenerator().generatePdf();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }
}

class Product {
  final String name;
  final String hsnSac;
  final int qty;
  final double rate;
  final double gst;
  final double amount;

  Product({
    required this.name,
    required this.hsnSac,
    required this.qty,
    required this.rate,
    required this.gst,
    required this.amount,
  });
}
