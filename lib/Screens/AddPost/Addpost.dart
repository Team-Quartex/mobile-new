import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:trova/class/post_class.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final PostClass _postClass = PostClass();

  List<File> _images = [];

  // Function to pick images
  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Pick only images
      allowMultiple: true, // Allow selecting multiple images
    );

    if (result != null) {
      // Limit to 5 images
      if (_images.length + result.files.length <= 5) {
        setState(() {
          // Add the selected images to the list
          _images.addAll(result.files.map((file) => File(file.path!)));
        });
      } else {
        // Show error if more than 5 images are selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can select a maximum of 5 images')),
        );
      }
    }
  }

  // Function to remove image at a specific index
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> submitPost() async {
    try {
      // Upload images
      List<String> imageFilenames = [];
      if (_images.isNotEmpty) {
        imageFilenames = await _postClass.uploadImages(_images);
      }

      // Add post
      await _postClass.addPost(
        description: _postController.text,
        location: _locationController.text,
        images: imageFilenames,
      );

      // Clear form and show success message
      setState(() {
        _postController.clear();
        _locationController.clear();
        _images.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF238688),
                  ),
                  child: const Text(
                    'Add Images',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Flexible(
                  child: Text(
                    'Choose a maximum of 5 images',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(
                _images.length,
                (index) => Stack(
                  children: [
                    Image.file(
                      _images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () => _removeImage(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF238688),
                    ),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                SizedBox(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD3EBE8),
                    ),
                    child: const Text(
                      'Discard',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
