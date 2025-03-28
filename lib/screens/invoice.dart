
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Product_model {
  final String name;
  final String hsnSac;
  final int qty;
  final double rate;
  final double gst;
  final double amount;

  Product_model({
    required this.name,
    required this.hsnSac,
    required this.qty,
    required this.rate,
    required this.gst,
    required this.amount,
  });
}

class PdfGenerator {
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    List<Product_model> products = [
      Product_model(name: "Product 1", hsnSac: "1234", qty: 5, rate: 100, gst: 18, amount: 590),
      Product_model(name: "Product 2", hsnSac: "5678", qty: 3, rate: 200, gst: 12, amount: 672),
    ];

    // Load the logo and signature
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
                    pw.Container(
                      width: 100,
                      height: 60,
                      child: pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.cover),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("SHRI GURU PLASTIC", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text("F3, B ROAD, SHADE NO.3317 DARED, JAMNAGAR", style: pw.TextStyle(fontSize: 10)),
                        pw.Text("Mo. 9924475849", style: pw.TextStyle(fontSize: 10)),
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
                      pw.Text("Cash / Debit", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Invoice No.: GT/394", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Divider(thickness: 1),

                // Customer & Bill Details
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
                              pw.Text("Name & Address", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text("SHRI GURU PLASTIC", style: pw.TextStyle(fontSize: 9)),
                              pw.Text("F3, B ROAD, SHADE NO.3317 DARED, JAMNAGAR", style: pw.TextStyle(fontSize: 9)),
                              pw.Text("9924475849", style: pw.TextStyle(fontSize: 9)),
                              pw.Text("Place of Supply: 24-Gujarat", style: pw.TextStyle(fontSize: 9)),
                              pw.Text("GSTIN No.: 24AMZPB4007H1Z5", style: pw.TextStyle(fontSize: 9)),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Bill No.: GT/394", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text("Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}", style: pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),

                pw.SizedBox(height: 5),
                pw.Divider(thickness: 1),

                // Product Table
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

                      // Product Rows
                      ...List.generate(10, (index) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(child: pw.Text(index < products.length ? (index + 1).toString() : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].name : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].hsnSac : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].qty.toString() : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].rate.toString() : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].gst.toString() : ""), padding: pw.EdgeInsets.all(8)),
                            pw.Padding(child: pw.Text(index < products.length ? products[index].amount.toString() : ""), padding: pw.EdgeInsets.all(8)),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  void printPdf() async {
    final pdfData = await generatePdf();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }
}
