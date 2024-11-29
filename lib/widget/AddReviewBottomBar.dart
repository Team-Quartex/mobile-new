import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import '../class/product_class.dart';

class AddReviewBottomBar extends StatefulWidget {
  final String productId; // Expecting a String here

  AddReviewBottomBar({super.key, required this.productId});

  @override
  _AddReviewBottomBarState createState() => _AddReviewBottomBarState();
}

class _AddReviewBottomBarState extends State<AddReviewBottomBar> {
  double _rating = 2.5;  // Default rating
  TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    final reviewContent = _reviewController.text.trim();
    if (reviewContent.isNotEmpty) {
      try {
        final response = await ProductClass().addReview(
          widget.productId,
          reviewContent,
          _rating,
        );

        if (response != null) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add review')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a Review',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          RatingStars(
            value: _rating,
            onValueChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
            starColor: const Color.fromARGB(255, 250, 166, 18),
            starOffColor: const Color.fromARGB(176, 0, 0, 0),
          ),
          SizedBox(height: 20),

          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: 'Write your review...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            maxLines: 4,
          ),
          SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF238688),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              child: Text(
                'Submit Review',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
