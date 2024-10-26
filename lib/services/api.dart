import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;

// Image Filters class definition
class ImageFilters {
  static ColorFilter sepiaTone() {
    return const ColorFilter.matrix([
     0.696, 0.384, 0.094, 0, 0,
      0.174, 0.843, 0.084, 0, 0,
      0.136, 0.267, 0.566, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  static ColorFilter blackAndWhite() {
    return const ColorFilter.matrix([
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  static ColorFilter warmGlow() {
    return const ColorFilter.matrix([
      1.2, 0, 0, 0, 0,
      0, 1.1, 0, 0, 0,
      0, 0, 0.9, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  static ColorFilter coolTint() {
    return const ColorFilter.matrix([
      0.9, 0, 0, 0, 0,
      0, 1.0, 0, 0, 0,
      0, 0, 1.2, 0, 0,
      0, 0, 0, 1, 0,
    ]);
  }

  static ColorFilter highContrast() {
    return const ColorFilter.matrix([
   1.25, 0, 0, 0, -63.75,
      0, 1.25, 0, 0, -63.75,
      0, 0, 1.25, 0, -63.75,
      0, 0, 0, 1, 0,
    ]);
  }
}

class VignettePainter extends CustomPainter {
  final double intensity;

  VignettePainter({this.intensity = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RadialGradient gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Colors.transparent,
        Colors.black.withOpacity(intensity),
      ],
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(VignettePainter oldDelegate) => false;
}

// Main App
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Filter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageFilterDemo(),
    );
  }
}

class ImageFilterDemo extends StatefulWidget {
  const ImageFilterDemo({Key? key}) : super(key: key);

  @override
  _ImageFilterDemoState createState() => _ImageFilterDemoState();
}

class _ImageFilterDemoState extends State<ImageFilterDemo> {
  String currentFilter = 'Normal';
  bool enableVignette = false;
  bool enableGrain = false;

  Widget _buildFilteredImage(Image image) {
    Widget processedImage = image;

    // Apply color filters
    final filters = _getSelectedFilters();
    for (final filter in filters) {
      processedImage = ColorFiltered(
        colorFilter: filter,
        child: processedImage,
      );
    }

    // Stack effects
    return Stack(
      children: [
        processedImage,
        if (enableVignette)
          Positioned.fill(
            child: CustomPaint(
              painter: VignettePainter(),
            ),
          ),
        if (enableGrain)
          Positioned.fill(
            child: CustomPaint(
              // painter: VintageGrainPainter(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Filter Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _buildFilteredImage(
                Image.asset(
                  'assets/cold.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Filter selection dropdown
                DropdownButton<String>(
                  value: currentFilter,
                  isExpanded: true,
                  items: [
                    'Normal',
                    'Sepia',
                    'Black & White',
                    'Warm Glow',
                    'Cool Tint',
                    'High Contrast',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      currentFilter = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Effect toggles
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Vignette'),
                        value: enableVignette,
                        onChanged: (bool? value) {
                          setState(() {
                            enableVignette = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Grain'),
                        value: enableGrain,
                        onChanged: (bool? value) {
                          setState(() {
                            enableGrain = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ColorFilter> _getSelectedFilters() {
    switch (currentFilter) {
      case 'Sepia':
        return [ImageFilters.sepiaTone()];
      case 'Black & White':
        return [ImageFilters.blackAndWhite()];
      case 'Warm Glow':
        return [ImageFilters.warmGlow()];
      case 'Cool Tint':
        return [ImageFilters.coolTint()];
      case 'High Contrast':
        return [ImageFilters.highContrast()];
      default:
        return [];
    }
  }
}
