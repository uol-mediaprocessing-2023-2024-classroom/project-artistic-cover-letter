class ImageCacheService {
  final Map<String, dynamic> _cache = {};

  void cacheImage(String id, dynamic imageData) {
    _cache[id] = imageData;
  }

  dynamic getImage(String id) {
    return _cache[id];
  }

  bool containsImage(String id) {
    return _cache.containsKey(id);
  }
}
