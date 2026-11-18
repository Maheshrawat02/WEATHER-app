// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:weather/modules/weather/controllers/weather_controller.dart';
// import 'package:weather/modules/weather/views/forecast_view.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   final TextEditingController searchController = TextEditingController();

//   late final WeatherController controller;

//   static const Color primaryColor = Color(0xff635BFF);
//   static const Color backgroundColor = Color(0xffF5F6FC);
//   static const Color textColor = Color(0xff20243A);

//   @override
//   void initState() {
//     super.initState();

//     controller = Get.isRegistered<WeatherController>()
//         ? Get.find<WeatherController>()
//         : Get.put(WeatherController());
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   Future<void> searchWeather() async {
//     final city = searchController.text.trim();

//     if (city.isEmpty) return;

//     FocusScope.of(context).unfocus();
//     await controller.searchWeather(city);
//   }

//   // Friendly error message for incorrect city names
//   String getFriendlyErrorMessage(String error) {
//     final message = error.toLowerCase();

//     if (message.contains('404') ||
//         message.contains('city not found') ||
//         message.contains('not found') ||
//         message.contains('invalid city')) {
//       return 'City not found! Please check the spelling '
//           'or try another city name.';
//     }

//     return 'Unable to fetch weather information. '
//         'Please check your internet connection and try again.';
//   }

//   IconData getWeatherIcon(String condition) {
//     final value = condition.toLowerCase();

//     if (value.contains('rain') || value.contains('drizzle')) {
//       return Icons.water_drop_rounded;
//     }

//     if (value.contains('cloud')) {
//       return Icons.cloud_rounded;
//     }

//     if (value.contains('snow')) {
//       return Icons.ac_unit_rounded;
//     }

//     if (value.contains('thunder') || value.contains('storm')) {
//       return Icons.thunderstorm_rounded;
//     }

//     if (value.contains('mist') ||
//         value.contains('fog') ||
//         value.contains('haze')) {
//       return Icons.cloud_queue_rounded;
//     }

//     if (value.contains('clear') || value.contains('sun')) {
//       return Icons.wb_sunny_rounded;
//     }

//     return Icons.cloud_rounded;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      

//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 650),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 22,
//                       vertical: 25,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header
//                         Row(
//                           children: [
//                             Container(
//                               height: 48,
//                               width: 48,
//                               decoration: BoxDecoration(
//                                 color: primaryColor.withOpacity(0.12),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: const Icon(
//                                 Icons.wb_sunny_rounded,
//                                 color: primaryColor,
//                                 size: 28,
//                               ),
//                             ),
      
//                             const SizedBox(width: 12),
      
//                             const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Weatherly',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: textColor,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Your daily weather companion',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.blueGrey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
      
//                         const SizedBox(height: 35),
      
//                         // Welcome Text
//                         const Text(
//                           'Discover the weather',
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                             color: textColor,
//                           ),
//                         ),
      
//                         const SizedBox(height: 7),
      
//                         const Text(
//                           'Search any city to check its current weather.',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.blueGrey,
//                           ),
//                         ),
      
//                         const SizedBox(height: 22),
      
//                         // Search Field
//                         Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: searchController,
//                                 textInputAction: TextInputAction.search,
//                                 onSubmitted: (_) => searchWeather(),
//                                 decoration: InputDecoration(
//                                   hintText: 'Search city name...',
//                                   hintStyle: const TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 14,
//                                   ),
//                                   prefixIcon: const Icon(
//                                     Icons.location_on_outlined,
//                                     color: primaryColor,
//                                   ),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       const EdgeInsets.symmetric(
//                                         vertical: 18,
//                                       ),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                     borderSide: BorderSide(
//                                       color: Colors.grey.shade200,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                     borderSide: const BorderSide(
//                                       color: primaryColor,
//                                       width: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
      
//                             const SizedBox(width: 12),
      
//                             SizedBox(
//                               height: 57,
//                               width: 57,
//                               child: ElevatedButton(
//                                 onPressed: searchWeather,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryColor,
//                                   foregroundColor: Colors.white,
//                                   elevation: 0,
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                 ),
//                                 child: const Icon(
//                                   Icons.search_rounded,
//                                   size: 27,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
      
//                         const SizedBox(height: 30),
      
//                         // Weather Result
//                         Obx(() {
//                           if (controller.isLoading.value) {
//                             return Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(35),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               child: const Column(
//                                 children: [
//                                   CircularProgressIndicator(
//                                     color: primaryColor,
//                                   ),
//                                   SizedBox(height: 15),
//                                   Text(
//                                     'Getting weather information...',
//                                     style: TextStyle(
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
      
//                           if (controller.error.value.isNotEmpty) {
//                             return Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(25),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(22),
//                               ),
//                               child: Column(
//                                 children: [
//                                   const Icon(
//                                     Icons.cloud_off_rounded,
//                                     size: 45,
//                                     color: Colors.redAccent,
//                                   ),
//                                   const SizedBox(height: 12),
//                                   Text(
//                                     getFriendlyErrorMessage(
//                                       controller.error.value,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       color: Colors.redAccent,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
      
//                           if (controller.weather.value == null) {
//                             return Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 45,
//                                 horizontal: 20,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               child: const Column(
//                                 children: [
//                                   Icon(
//                                     Icons.cloud_queue_rounded,
//                                     size: 65,
//                                     color: Color(0xffA5A9C5),
//                                   ),
//                                   SizedBox(height: 15),
//                                   Text(
//                                     'Explore the weather',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Enter a city name above to see\n'
//                                     'the latest weather information.',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Colors.blueGrey,
//                                       height: 1.5,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
      
//                           final weather = controller.weather.value!;
      
//                           return Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(25),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   Color(0xff7168FF),
//                                   Color(0xff5146D8),
//                                   Color(0xff3935A9),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(28),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: primaryColor.withOpacity(0.25),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 10),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 // City
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                   children: [
//                                     const Icon(
//                                       Icons.location_on_rounded,
//                                       color: Colors.white70,
//                                       size: 19,
//                                     ),
//                                     const SizedBox(width: 5),
//                                     Flexible(
//                                       child: Text(
//                                         weather.cityName,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 23,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
      
//                                 const SizedBox(height: 22),
      
//                                 // Weather Icon
//                                 Icon(
//                                   getWeatherIcon(weather.condition),
//                                   size: 105,
//                                   color: Colors.white,
//                                 ),
      
//                                 const SizedBox(height: 12),
      
//                                 // Temperature
//                                 Text(
//                                   '${weather.temperature}°C',
//                                   style: const TextStyle(
//                                     fontSize: 65,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     height: 1.1,
//                                   ),
//                                 ),
      
//                                 const SizedBox(height: 10),
      
//                                 // Weather Condition
//                                 Text(
//                                   weather.condition,
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 19,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
      
//                                 const SizedBox(height: 25),
      
//                                 // Bottom Information
//                                 Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 15,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.13),
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                   child: const Text(
//                                     'CURRENT WEATHER',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 12,
//                                       letterSpacing: 2,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }),
      
//                         const SizedBox(height: 28),
      
//                         // Forecast Section
//                         Row(
//                           children: [
//                             const Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Weather Forecast',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   SizedBox(height: 5),
//                                   Text(
//                                     'Stay updated with upcoming weather',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
      
//                             const SizedBox(width: 8),
      
//                             TextButton(
//                               onPressed: () {
//                                 Get.to(() => ForecastView());
//                               },
//                               child: const Text(
//                                 'View all',
//                                 style: TextStyle(
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
      
//                         const SizedBox(height: 30),
      
//                         // Forecast Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 58,
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Get.to(() => ForecastView());
//                             },
//                             icon: const Icon(
//                               Icons.calendar_month_rounded,
//                               size: 21,
//                             ),
//                             label: const Text(
//                               'Explore Weather Forecast',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryColor,
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                           ),
//                         ),
      
//                         const SizedBox(height: 25),
      
//                         const Center(
//                           child: Text(
//                             'Weather information at your fingertips',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.blueGrey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
      
      
//     );
//   }
// }


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

  late final WeatherController controller;

  // CHANGED: colors now match the reference (orange -> light grey fade)
  static const Color textColor = Color(0xff111111);

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<WeatherController>()
        ? Get.find<WeatherController>()
        : Get.put(WeatherController());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> searchWeather() async {
    final city = searchController.text.trim();

    if (city.isEmpty) return;

    FocusScope.of(context).unfocus();
    await controller.searchWeather(city);
  }

  // UNCHANGED
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

  // CHANGED: outlined icons to match the thin sun icon in the reference
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

  // CHANGED: simple date/time formatting (no extra package needed)
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

  // CHANGED: the old search field is now opened from the menu icon
  void _openSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: TextField(
          controller: searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            Navigator.pop(ctx);
            searchWeather();
          },
          decoration: InputDecoration(
            hintText: 'Search city name...',
            filled: true,
            fillColor: const Color(0xffF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      // CHANGED: whole body replaced with the new layout
      body: Stack(
        children: [
          // CHANGED: background gradient (orange at top fading to light grey)
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
      
          // CHANGED: diagonal light streaks in the top-left corner
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
      
                  // CHANGED: header = date/time on left, menu icon on right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                      const Spacer(),
                      GestureDetector(
                        onTap: _openSearch,
                        child: const Icon(
                          Icons.menu_rounded,
                          size: 22,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
      
                  // CHANGED: centered weather block
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
                          child: Text(
                            getFriendlyErrorMessage(controller.error.value),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
      
                      if (controller.weather.value == null) {
                        return Center(
                          child: GestureDetector(
                            onTap: _openSearch,
                            child: const Text(
                              'Tap the menu to search a city',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
      
                      final weather = controller.weather.value!;
      
                      // NOTE: replace with real values if your model has
                      // them (e.g. weather.tempMax / weather.tempMin)
                      final temp = (weather.temperature as num).round();
                      final high = temp + 1;
                      final low = temp - 10;
      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // High temp + arrow line
                          Text(
                            '$high',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 26,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.black45,
                          ),
      
                          // City
                          Text(
                            weather.cityName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
      
                          // Big temperature with degree circle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$temp',
                                style: const TextStyle(
                                  fontSize: 150,
                                  height: 1.05,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -6,
                                  color: textColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: textColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
      
                          // Condition
                          Text(
                            weather.condition,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
      
                          // Arrow line + low temp
                          Container(
                            width: 1,
                            height: 26,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.black45,
                          ),
                          Text(
                            '$low',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
      
                  // CHANGED: hourly row at the bottom (tap opens ForecastView)
                  Obx(() {
                    final weather = controller.weather.value;
                    if (weather == null) return const SizedBox(height: 40);
      
                    // NOTE: placeholder hourly data using the current temp.
                    // Replace with real hourly forecast values when available.
                    final temp = (weather.temperature as num).round();
      
                    return GestureDetector(
                      onTap: () => Get.to(() => ForecastView()),
                      child: SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 26),
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
                      ),
                    );
                  }),
      
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CHANGED: new painter for the soft white diagonal streaks (top-left)
class _StreakPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Each streak: start x offset (as fraction of width), thickness, opacity
    final streaks = <List<double>>[
      [-0.83, 8, 0.35],
      [-0.78, 10, 0.35],
      [-0.60, 10, 0.40],
      [-0.50, 10, 0.40],
      [-0.40, 10, 0.40],
      [-0.30, 10, 0.40],


      [-0.25, 8, 0.35],
      [-0.10, 70, 0.10],
      [0.05, 18, 0.35],
      [0.12, 34, 0.22],
      [0.22, 10, 0.45],
      [0.30, 46, 0.14],
      // [0.42, 8, 0.35],
      // [0.55, 24, 0.18],
      // [0.70, 6, 0.25],
    ];

    for (final s in streaks) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(s[2])
        ..strokeWidth = s[1]
        ..strokeCap = StrokeCap.butt
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s[1] * 0.25);

      // Lines run from bottom-left up to top-right at a shallow angle
      final startX = size.width * s[0];
      final start = Offset(startX - size.width * 0.2, size.height * 0.40);
      final end = Offset(startX + size.width * 0.9, -size.height * 0.03);

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

