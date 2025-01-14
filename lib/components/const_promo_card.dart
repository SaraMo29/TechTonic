import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PromoCarousel extends StatelessWidget {
  PromoCarousel({super.key});

  final List<Map<String, String>> promoData = [
    {
      "discount": "40",
      "title": "Today's Special",
      "description": "Get a discount for every course order!\nOnly valid for today!",
    },
    {
      "discount": "30",
      "title": "Summer Sale",
      "description": "Special offer for summer courses!\nLimited time only.",
    },
    {
      "discount": "20",
      "title": "New Year Offer",
      "description": "Kickstart your year with amazing courses!\nHurry up now.",
    },
    {
      "discount": "50",
      "title": "Black Friday Deal",
      "description": "Unbelievable deals for all courses!\nDon't miss out!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.9,
        ),
        items: promoData.map((data) {
          return Builder(
            builder: (BuildContext context) {
              return PromoCard(
                discount: data["discount"]!,
                title: data["title"]!,
                description: data["description"]!,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String discount;
  final String title;
  final String description;

  const PromoCard({
    super.key,
    required this.discount,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                "$discount% OFF",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
