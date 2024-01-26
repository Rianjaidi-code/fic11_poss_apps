import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:fic11_pos_apps/core/extensions/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/presentation/home/models/order_item.dart';

class CwbPrint {
  CwbPrint._init();

  static final CwbPrint instance = CwbPrint._init();

  Future<List<int>> printOrder(
    List<OrderItem> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    String namaKasir,
  ) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.reset();

    ByteData data = await rootBundle.load('assets/images/logo_print.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);
    //  if (data.lengthInBytes > 0) {
    //     final Uint8List imageBytes = data.buffer.asUint8List();
    //     // decode the bytes into an image
    //     final decodedImage = img.decodeImage(imageBytes)!;
    //     // Create a black bottom layer
    //     // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
    //     img.Image thumbnail = img.copyResize(decodedImage, height: 130);
    //     // creates a copy of the original image with set dimensions
    //     img.Image originalImg = img.copyResize(decodedImage, width: 380, height: 130);
    //     // fills the original image with a white background
    //     img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));
    //     var padding = (originalImg.width - thumbnail.width) / 2;

    //     //insert the image inside the frame and center it
    //     // drawImage(originalImg, thumbnail, dstX: padding.toInt());

    //     // convert image to grayscale
    //     var grayscaleImage = img.grayscale(originalImg);

    //     bytes += generator.feed(1);
    //     // bytes += generator.imageRaster(img.decodeImage(imageBytes)!, align: PosAlign.center);
    //     bytes += generator.imageRaster(grayscaleImage, align: PosAlign.center);
    //     bytes += generator.feed(1);
    //   }

    bytes += generator.imageRaster(image!);

    bytes += generator.feed(1);

    bytes += generator.text('Kirai Kopi',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    // bytes += generator.text('Code with Bahri',
    //     styles: const PosStyles(
    //       bold: true,
    //       align: PosAlign.center,
    //       height: PosTextSize.size1,
    //       width: PosTextSize.size1,
    //     ));

    bytes += generator.text('Jalan Kalisari No.1',
        styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.text(
        'Date : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.text('Website: www.kiraikopi.com',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    // bytes += generator.text('Start 12 Desember 2023',
    //     styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.feed(1);

    bytes += generator.hr(ch: '-', linesAfter: 1);

    bytes += generator.text('Pesanan:',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    //for from data
    for (final product in products) {
      bytes += generator.text(product.product.name,
          styles: const PosStyles(align: PosAlign.left));

      bytes += generator.row([
        PosColumn(
          text: '${product.quantity} x @${product.product.price}}',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text:
              '${(product.product.price * product.quantity).currencyFormatRp}',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.hr(ch: '-', linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: totalPrice.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.hr(ch: '-', linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'Bayar',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: nominalBayar.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Kembalian',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: (nominalBayar - totalPrice).currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Pembayaran',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: paymentMethod,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.drawer(pin: PosDrawer.pin2);

    bytes += generator.feed(1);
    bytes += generator.text('Terima kasih',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(3);

    return bytes;
  }
}
