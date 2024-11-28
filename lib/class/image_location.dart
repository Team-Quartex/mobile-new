class ImageLocation {
  String location = 'http://172.20.10.4:8000/uploads/';

  String imageUrl(String filename) {
    return location + filename;
  }
}
