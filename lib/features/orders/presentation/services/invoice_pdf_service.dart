import 'dart:typed_data';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

class InvoicePdfService {
  /// توليد وتخطيط ملف الـ PDF للطباعة أو الحفظ
  static Future<void> printInvoice(OrderEntity order) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => generateInvoiceBytes(order, format),
      name: 'فاتورة_طلب_${order.id}.pdf',
    );
  }

  /// مشاركة ملف الـ PDF كملف جاهز
  static Future<void> shareInvoice(OrderEntity order) async {
    final bytes = await generateInvoiceBytes(order, PdfPageFormat.a4);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'فاتورة_طلب_${order.id}.pdf',
    );
  }

  /// إنشاء مصفوفة بايتس الفاتورة بتنسيق احترافي يدعم العربية
  static Future<Uint8List> generateInvoiceBytes(
    OrderEntity order,
    PdfPageFormat format,
  ) async {
    final pdf = pw.Document();

    // تحميل خط عربي من Google Fonts
    final pw.Font arabicFont = await PdfGoogleFonts.cairoRegular();
    final pw.Font arabicBoldFont = await PdfGoogleFonts.cairoBold();

    final dateFormat = intl.DateFormat('yyyy/MM/dd • hh:mm a');
    final formattedDate = dateFormat.format(order.orderDate);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicBoldFont,
        ),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'عضلات أقوى | Stronger Muscles',
                            style: pw.TextStyle(
                              font: arabicBoldFont,
                              fontSize: 18,
                              color: PdfColors.blueGrey900,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'لوحة إدارة المتجر - فاتورة مبيعات',
                            style: pw.TextStyle(
                              font: arabicFont,
                              fontSize: 11,
                              color: PdfColors.grey700,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: pw.BorderRadius.circular(8),
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'فاتورة طلب #${order.id}',
                              style: pw.TextStyle(
                                font: arabicBoldFont,
                                fontSize: 13,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              formattedDate,
                              style: pw.TextStyle(
                                font: arabicFont,
                                fontSize: 9,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 18),
                  pw.Divider(color: PdfColors.grey300, thickness: 1),
                  pw.SizedBox(height: 12),

                  // --- Customer & Order Info Cards ---
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Customer Info
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey50,
                            borderRadius: pw.BorderRadius.circular(8),
                            border: pw.Border.all(color: PdfColors.grey200),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'بيانات العميل',
                                style: pw.TextStyle(
                                  font: arabicBoldFont,
                                  fontSize: 11,
                                  color: PdfColors.blueGrey800,
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Text(
                                'الاسم: ${order.userName.isNotEmpty ? order.userName : 'غير محدد'}',
                                style: pw.TextStyle(font: arabicFont, fontSize: 10),
                              ),
                              if (order.phoneNumber != null && order.phoneNumber!.isNotEmpty)
                                pw.Text(
                                  'الهاتف: ${order.phoneNumber}',
                                  style: pw.TextStyle(font: arabicFont, fontSize: 10),
                                ),
                              if (order.userEmail.isNotEmpty)
                                pw.Text(
                                  'البريد: ${order.userEmail}',
                                  style: pw.TextStyle(font: arabicFont, fontSize: 10),
                                ),
                            ],
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 14),
                      // Payment & Shipping
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(12),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey50,
                            borderRadius: pw.BorderRadius.circular(8),
                            border: pw.Border.all(color: PdfColors.grey200),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'تفاصيل الشحن والدفع',
                                style: pw.TextStyle(
                                  font: arabicBoldFont,
                                  fontSize: 11,
                                  color: PdfColors.blueGrey800,
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Text(
                                'طريقة الدفع: ${order.paymentMethod.isNotEmpty ? order.paymentMethod : 'غير محدد'}',
                                style: pw.TextStyle(font: arabicFont, fontSize: 10),
                              ),
                              pw.Text(
                                'حالة الدفع: ${_getPaymentStatusText(order.paymentStatus)}',
                                style: pw.TextStyle(font: arabicFont, fontSize: 10),
                              ),
                              if (order.shippingAddress?.fullAddress != null)
                                pw.Text(
                                  'العنوان: ${order.shippingAddress!.fullAddress}',
                                  style: pw.TextStyle(font: arabicFont, fontSize: 10),
                                  maxLines: 2,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  // --- Items Table ---
                  pw.Text(
                    'قائمة المنتجات',
                    style: pw.TextStyle(
                      font: arabicBoldFont,
                      fontSize: 12,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                  pw.SizedBox(height: 8),

                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey300,
                      width: 0.5,
                    ),
                    children: [
                      // Table Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          _buildTableCell('#', isHeader: true, font: arabicBoldFont),
                          _buildTableCell('المنتج', isHeader: true, font: arabicBoldFont, flex: 3),
                          _buildTableCell('السعر', isHeader: true, font: arabicBoldFont),
                          _buildTableCell('الكمية', isHeader: true, font: arabicBoldFont),
                          _buildTableCell('الإجمالي', isHeader: true, font: arabicBoldFont),
                        ],
                      ),
                      // Table Rows
                      ...order.items.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final item = entry.value;
                        return pw.TableRow(
                          children: [
                            _buildTableCell('$index', font: arabicFont),
                            _buildTableCell(item.productName, font: arabicFont, flex: 3),
                            _buildTableCell('${item.unitPrice.toStringAsFixed(2)} ر.س', font: arabicFont),
                            _buildTableCell('${item.quantity}', font: arabicFont),
                            _buildTableCell('${item.subtotal.toStringAsFixed(2)} ر.س', font: arabicBoldFont),
                          ],
                        );
                      }),
                    ],
                  ),

                  pw.SizedBox(height: 16),

                  // --- Summary Table ---
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                        width: 240,
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey100,
                          borderRadius: pw.BorderRadius.circular(8),
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          children: [
                            _buildSummaryLine('المجموع الفرعي:', '${order.subtotal.toStringAsFixed(2)} ر.س', font: arabicFont),
                            pw.SizedBox(height: 4),
                            _buildSummaryLine('تكلفة الشحن:', '${order.shippingCost.toStringAsFixed(2)} ر.س', font: arabicFont),
                            if (order.discount > 0) ...[
                              pw.SizedBox(height: 4),
                              _buildSummaryLine('الخصم:', '-${order.discount.toStringAsFixed(2)} ر.س', font: arabicFont, color: PdfColors.red700),
                            ],
                            pw.Divider(color: PdfColors.grey400),
                            _buildSummaryLine(
                              'الإجمالي النهائي:',
                              '${order.totalAmount.toStringAsFixed(2)} ر.س',
                              font: arabicBoldFont,
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.Spacer(),

                  // --- Footer ---
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 6),
                  pw.Center(
                    child: pw.Text(
                      'شكراً لتعاملكم معنا • عضلات أقوى للياقة البدنية والمكملات الغذائية',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    int flex = 1,
    required pw.Font font,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildSummaryLine(
    String label,
    String value, {
    required pw.Font font,
    double fontSize = 10,
    PdfColor? color,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            fontSize: fontSize,
            color: color ?? PdfColors.grey800,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: font,
            fontSize: fontSize,
            color: color ?? PdfColors.grey800,
          ),
        ),
      ],
    );
  }

  static String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'مدفوع';
      case PaymentStatus.pending:
        return 'معلق / قيد الانتظار';
      case PaymentStatus.failed:
        return 'فشل الدفع';
      case PaymentStatus.refunded:
        return 'مسترد';
    }
  }
}
