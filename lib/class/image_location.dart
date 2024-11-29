class ImageLocation {
  String location = 'http://192.168.0.102:8000/uploads/';

  String imageUrl(String filename) {
    return location + filename;
  }
}
