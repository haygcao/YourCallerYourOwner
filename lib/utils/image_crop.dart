import 'dart:ui' as ui;

Future<ui.Image> cropImage(ui.Image image, Rect cropRect) async {
  // 将图片转换为字节数组
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  // 创建新的图像
  final newImage = await ui.decodeImageFromPixels(
    bytes.buffer.asUint8List(),
    width: cropRect.width.toInt(),
    height: cropRect.height.toInt(),
  );

  // 返回裁剪后的图像
  return newImage;
}
