
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/modules/weather/controllers/weather_controller.dart';

class ForecastView extends StatelessWidget {
  ForecastView({super.key});

  final WeatherController controller = Get.find<WeatherController>();

  // CHANGED: colors now match HomeView (black text on orange -> grey fade)
  static const Color textColor = Color(0xff111111);
  static const Color secondaryTextColor = Colors.black54;

  // CHANGED: same date/time helpers as HomeView
  String _dateText(DateTime d) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
  }

  String _timeText(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m ${d.hour >= 12 ? 'pm' : 'am'}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      // CHANGED: AppBar removed, body is a Stack with the HomeView background
      body: Stack(
        children: [
          // CHANGED: same gradient as HomeView
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffFDB95E),
                  Color(0xffFBA85A),
                  Color(0xffFAAE72),
                  Color(0xffF7E3D3),
                  Color(0xffF3F3F3),
                  Color(0xffF3F3F3),
                ],
                stops: [0.0, 0.25, 0.40, 0.62, 0.75, 1.0],
              ),
            ),
          ),

          // CHANGED: same diagonal light streaks as HomeView
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ForecastStreakPainter()),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // CHANGED: header = back icon (left) + date/time (right)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 5, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _dateText(now),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            Text(
                              _timeText(now),
                              style: const TextStyle(
                                fontSize: 12,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: textColor,
                            strokeWidth: 2,
                          ),
                        );
                      }

                      if (controller.error.value.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              controller.error.value,
                              textAlign: TextAlign.center,
                              // CHANGED: text color matches HomeView
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      }

                      if (controller.weather.value == null ||
                          controller.forecasts.isEmpty) {
                        return const Center(
                          child: Text(
                            'Forecast data is not available.',
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                            ),
                          ),
                        );
                      }

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 750),
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 25),
                            children: [
                              // CHANGED: same title style as HomeView ListTile
                              const ListTile(
                                title: Text(
                                  'Upcoming Forecast',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Stay prepared with the upcoming weather conditions.',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Forecast count row
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Daily Weather Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      '${controller.forecasts.length} forecasts',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Forecast list
                              ...List.generate(
                                controller.forecasts.length,
                                (index) {
                                  final forecast = controller.forecasts[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 20,
                                    ),
                                    // CHANGED: transparent glass card with a
                                    // thin border (same look as HomeView
                                    // Forecast button)
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.black38,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                forecast.date.toString(),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: secondaryTextColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 9),
                                              Text(
                                                forecast.condition,
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // CHANGED: temperature is now black
                                        // (was purple)
                                        Text(
                                          '${forecast.temperature}°C',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CHANGED: same streak painter as HomeView (named differently because
// _StreakPainter is private to home_view.dart)
class _ForecastStreakPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streaks = <List<double>>[
      [-0.75, 10, 0.45],
      [-0.70, 3, 0.30],
      [-0.65, 7, 0.25],

      [-0.58, 6, 0.10],
      [-0.54, 4, 0.20],
      [-0.50, 10, 0.30],
      [-0.46, 5, 0.20],
      [-0.40, 10, 0.20],

      [-0.30, 10, 0.10],
      [-0.25, 8, 0.15],

      [-0.10, 40, 0.10],

      [-0.05, 6, 0.20],
      [0.09, 4, 0.20],
      [0.14, 18, 0.45],

      [0.20, 5, 0.20],
      [0.24, 9, 0.25],
      [0.28, 5, 0.10],
      [0.32, 3, 0.08],
    ];

    for (final s in streaks) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(s[2])
        ..strokeWidth = s[1]
        ..strokeCap = StrokeCap.butt
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s[1] * 0.25);

      final startX = size.width * s[0];
      final start = Offset(startX - size.width * 0.2, size.height * 0.40);
      final end = Offset(startX + size.width * 0.9, -size.height * 0.03);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


