import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/modules/weather/controllers/weather_controller.dart';

class ForecastView extends StatelessWidget {
  ForecastView({super.key});

  final WeatherController controller = Get.find<WeatherController>();

  static const Color primaryColor = Color(0xff635BFF);
  static const Color backgroundColor = Color(0xffF5F6FC);
  static const Color textColor = Color(0xff20243A);
  static const Color secondaryTextColor = Color(0xff7B8198);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
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
                style: const TextStyle(
                  color: Colors.redAccent,
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

        return LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 750,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  children: [
                    // Header Section
                    const Text(
                      'Upcoming Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Stay prepared with the upcoming weather conditions.',
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Forecast Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily Weather Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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

                    const SizedBox(height: 15),

                    // Forecast List
                    ...List.generate(
                      controller.forecasts.length,
                      (index) {
                        final forecast = controller.forecasts[index];

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xffE9EAF2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.035),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              // Date and Condition
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

                              // Temperature
                              Text(
                                '${forecast.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
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
          },
        );
      }),
    );
  }
}



