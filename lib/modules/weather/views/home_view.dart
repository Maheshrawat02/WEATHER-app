import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/modules/weather/controllers/weather_controller.dart';
import 'package:weather/modules/weather/views/forecast_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  late final WeatherController controller;

  static const Color textColor = Color(0xff111111);

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<WeatherController>()
        ? Get.find<WeatherController>()
        : Get.put(WeatherController());

    _searchFocus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> searchWeather() async {
    final city = searchController.text.trim();

    if (city.isEmpty) return;

    FocusScope.of(context).unfocus();
    await controller.searchWeather(city);
  }

  // CHANGED: brought back - clears the result and returns to the start state
  void _goBackToSearch() {
    FocusScope.of(context).unfocus();
    searchController.clear();
    controller.error.value = '';
    controller.weather.value = null;
  }

  String getFriendlyErrorMessage(String error) {
    final message = error.toLowerCase();

    if (message.contains('404') ||
        message.contains('city not found') ||
        message.contains('not found') ||
        message.contains('invalid city')) {
      return 'City not found! Please check the spelling '
          'or try another city name.';
    }

    return 'Unable to fetch weather information. '
        'Please check your internet connection and try again.';
  }

  IconData getWeatherIcon(String condition) {
    final value = condition.toLowerCase();

    if (value.contains('rain') || value.contains('drizzle')) {
      return Icons.water_drop_outlined;
    }
    if (value.contains('cloud')) {
      return Icons.cloud_outlined;
    }
    if (value.contains('snow')) {
      return Icons.ac_unit_rounded;
    }
    if (value.contains('thunder') || value.contains('storm')) {
      return Icons.thunderstorm_outlined;
    }
    if (value.contains('mist') ||
        value.contains('fog') ||
        value.contains('haze')) {
      return Icons.cloud_queue_rounded;
    }
    if (value.contains('clear') || value.contains('sun')) {
      return Icons.wb_sunny_outlined;
    }
    return Icons.cloud_outlined;
  }

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

  String _hourLabel(int hour) {
    final h = hour % 24;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12 ${h >= 12 ? 'pm' : 'am'}';
  }

  // Search field (same design as before)
  Widget _buildTopSearchField() {
    final bool focused = _searchFocus.hasFocus;

    return TextField(
      controller: searchController,
      focusNode: _searchFocus,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => searchWeather(),
      style: const TextStyle(color: textColor, fontSize: 15),
      cursorColor: textColor,
      decoration: InputDecoration(
        hintText: 'Search city name...',
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
        prefixIcon: const Icon(Icons.location_on_outlined, color: textColor),
        filled: focused,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: textColor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // CHANGED: Obx + PopScope wrapped around the Scaffold.
    // While a weather result is showing, system back goes to the start state
    // instead of exiting the app. On the start state, back exits as normal.
    return Obx(() {
      final bool canPop =
          controller.weather.value == null && controller.error.value.isEmpty;

      return PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _goBackToSearch();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
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

                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _StreakPainter()),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Discover the weather",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Search any city to check its current weather.",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        _buildTopSearchField(),

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

                            if (controller.weather.value == null) {
                              // error after a failed search
                              if (controller.error.value.isNotEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      getFriendlyErrorMessage(
                                          controller.error.value),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 210,
                                    ),
                                    Text(
                                      "Explore the weather",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Enter a city name above to see "
                                      "the latest weather information",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final weather = controller.weather.value!;

                            final temp = (weather.temperature as num).round();
                            final high = temp + 1;
                            final low = temp - 10;

                            return Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$high°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: _ArrowLine(up: true),
                                    ),

                                    Text(
                                      weather.cityName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$temp',
                                          style: const TextStyle(
                                            fontSize: 150,
                                            height: 1.05,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -4,
                                            color: textColor,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: textColor,
                                                width: 2.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      weather.condition,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),

                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: _ArrowLine(up: false),
                                    ),
                                    Text(
                                      '$low°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),

                        // "Weather Forecast" ListTile (only after a search)
                        Obx(() {
                          if (controller.weather.value == null) {
                            return const SizedBox.shrink();
                          }
                          return const Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                "Weather Forecast",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Stay updated with upcoming weather.",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        }),

                        // Hourly forecast row
                        Obx(() {
                          final weather = controller.weather.value;
                          if (weather == null) return const SizedBox.shrink();

                          final temp = (weather.temperature as num).round();

                          return SizedBox(
                            height: 90,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 50),
                              itemBuilder: (context, i) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$temp °C',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Icon(
                                      getWeatherIcon(weather.condition),
                                      size: 22,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _hourLabel(now.hour + i),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),

                        // Forecast button
                        Obx(() {
                          if (controller.weather.value == null) {
                            return const SizedBox(height: 28);
                          }
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 20, bottom: 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Get.to(() => ForecastView()),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.15),
                                      foregroundColor: textColor,
                                      side: const BorderSide(
                                          color: Colors.black38),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_month_outlined),
                                        Text(
                                          ' Explore Forecast',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                    "Weather information at your fringertips")
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ArrowLine extends StatelessWidget {
  final bool up;
  const _ArrowLine({required this.up});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 38,
      child: CustomPaint(painter: _ArrowLinePainter(up: up)),
    );
  }
}

class _ArrowLinePainter extends CustomPainter {
  final bool up;
  _ArrowLinePainter({required this.up});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;

    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), paint);

    final tipY = up ? 0.0 : size.height;
    final baseY = up ? 6.0 : size.height - 6.0;
    canvas.drawLine(Offset(cx, tipY), Offset(cx - 4, baseY), paint);
    canvas.drawLine(Offset(cx, tipY), Offset(cx + 4, baseY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StreakPainter extends CustomPainter {
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

