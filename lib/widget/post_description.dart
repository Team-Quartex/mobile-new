import 'package:flutter/material.dart';

class PostDescription extends StatefulWidget {
  final String description;

  const PostDescription({required this.description, super.key});

  @override
  _PostDescriptionState createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  bool isExpanded = false;
  late String truncatedText;
  late bool isOverflowing;

  @override
  void initState() {
    super.initState();
    // Truncate description to a certain character limit for initial view
    const int characterLimit = 150;
    if (widget.description.length > characterLimit) {
      isOverflowing = true;
      truncatedText = "${widget.description.substring(0, characterLimit)}...";
    } else {
      isOverflowing = false;
      truncatedText = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isExpanded ? widget.description : truncatedText,
            style: const TextStyle(fontSize: 14),
          ),
          if (isOverflowing) // Only show "See more/less" if the text overflows
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? "See less" : "See more",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
