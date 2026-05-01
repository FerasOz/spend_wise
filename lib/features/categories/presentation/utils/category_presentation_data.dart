import 'package:flutter/material.dart';

class CategoryPresentationData {
  const CategoryPresentationData._();

  static const String defaultIconName = 'shopping_cart';
  static const int defaultColorValue = 0xFFFF6B6B;

  static const List<String> iconNames = [
    'shopping_cart',
    'restaurant',
    'local_gas_station',
    'directions_car',
    'movie',
    'sports_esports',
    'health_and_safety',
    'favorite',
    'home',
    'build',
    'school',
    'travel_explore',
    'pets',
    'music_note',
    'fitness_center',
    'checkroom',
    'phone',
    'wifi',
    'electricity',
    'water_drop',
    'card_giftcard',
    'celebration',
  ];

  static const List<int> colorPalette = [
    0xFFFF6B6B,
    0xFFEE5A6F,
    0xFFC92A2A,
    0xFFFF922B,
    0xFFFD7E14,
    0xFFFCC419,
    0xFFFFD43B,
    0xFFC0EB75,
    0xFF69DB7C,
    0xFF37B24D,
    0xFF20C997,
    0xFF0C93E4,
    0xFF1971C2,
    0xFF7950F2,
    0xFF9775FA,
    0xFFD0BFFF,
    0xFFCED4DA,
  ];

  static const Map<String, IconData> iconMap = {
    'shopping_cart': Icons.shopping_cart_outlined,
    'restaurant': Icons.restaurant_outlined,
    'local_gas_station': Icons.local_gas_station_outlined,
    'directions_car': Icons.directions_car_outlined,
    'movie': Icons.movie_outlined,
    'sports_esports': Icons.sports_esports_outlined,
    'health_and_safety': Icons.health_and_safety_outlined,
    'favorite': Icons.favorite_outline,
    'home': Icons.home_outlined,
    'build': Icons.build_outlined,
    'school': Icons.school_outlined,
    'travel_explore': Icons.travel_explore_outlined,
    'pets': Icons.pets_outlined,
    'music_note': Icons.music_note_outlined,
    'fitness_center': Icons.fitness_center_outlined,
    'checkroom': Icons.checkroom_outlined,
    'phone': Icons.phone_outlined,
    'wifi': Icons.wifi_outlined,
    'electricity': Icons.bolt_outlined,
    'water_drop': Icons.water_drop_outlined,
    'card_giftcard': Icons.card_giftcard_outlined,
    'celebration': Icons.celebration_outlined,
  };

  static IconData iconFor(String iconName) {
    return iconMap[iconName] ?? Icons.shopping_cart_outlined;
  }
}
