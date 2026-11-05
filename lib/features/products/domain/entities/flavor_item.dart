/// Domain entity representing a product flavor with its display name and official store image URL.
class FlavorItem {
  final String name;
  final String? imageUrl;

  const FlavorItem({required this.name, this.imageUrl});

  /// The raw value stored in product flavor lists: "Name|ImageURL" or simple "Name"
  String get rawValue => (imageUrl != null && imageUrl!.trim().isNotEmpty)
      ? '$name|${imageUrl!.trim()}'
      : name;

  factory FlavorItem.fromRaw(String raw) {
    if (raw.contains('|')) {
      final parts = raw.split('|');
      final name = parts.first.trim();
      final url = parts.sublist(1).join('|').trim();
      return FlavorItem(
        name: name,
        imageUrl: url.isNotEmpty ? url : null,
      );
    }
    return FlavorItem(name: raw.trim(), imageUrl: null);
  }

  FlavorItem copyWith({String? name, String? imageUrl}) {
    return FlavorItem(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Official store preset flavors with verified CDN images
  static const List<FlavorItem> defaultPresets = [
    FlavorItem(
      name: 'Vanilla',
      imageUrl:
          'https://i.pinimg.com/1200x/34/05/1d/34051d682f6f93788f27d6d28280f2ff.jpg',
    ),
    FlavorItem(
      name: 'Strawberry',
      imageUrl:
          'https://i.pinimg.com/736x/49/7c/ec/497cecf2e260f0a9f35d6336b74c3d80.jpg',
    ),
    FlavorItem(
      name: 'Chocolate',
      imageUrl:
          'https://i.pinimg.com/736x/54/cc/0e/54cc0e7213b33cb9c1ee2451bb19d9a3.jpg',
    ),
    FlavorItem(
      name: 'Mango',
      imageUrl:
          'https://i.pinimg.com/736x/b8/4e/68/b84e6829e22824e4a244f6b9e72398bf.jpg',
    ),
    FlavorItem(
      name: 'Caramel',
      imageUrl:
          'https://i.pinimg.com/736x/e9/87/ae/e987aef33d3b7dbc41486a947ef65c25.jpg',
    ),
    FlavorItem(
      name: 'Cookies',
      imageUrl:
          'https://i.pinimg.com/736x/20/52/60/20526056fc1041a1e8781c6a4282eba2.jpg',
    ),
    FlavorItem(
      name: 'Banana',
      imageUrl:
          'https://i.pinimg.com/736x/41/45/53/41455324a095edc6a07ac57d67e6bdb7.jpg',
    ),
    FlavorItem(
      name: 'Berry',
      imageUrl:
          'https://i.pinimg.com/736x/33/69/52/33695284fb75b948cf641777a13d9aa5.jpg',
    ),
    FlavorItem(
      name: 'Coffee',
      imageUrl:
          'https://i.pinimg.com/736x/5e/03/98/5e0398fa88c4c64210c5143433afe9b2.jpg',
    ),
    FlavorItem(
      name: 'Cola',
      imageUrl:
          'https://i.pinimg.com/736x/5e/03/98/5e0398fa88c4c64210c5143433afe9b2.jpg',
    ),
    FlavorItem(
      name: 'Peanut',
      imageUrl:
          'https://i.pinimg.com/736x/6c/67/a4/6c67a495ebbf4db11d3e9ae3d40692b6.jpg',
    ),
    FlavorItem(
      name: 'Watermelon',
      imageUrl:
          'https://i.pinimg.com/736x/00/6e/de/006edeee57d453cef689c246f2dbd14c.jpg',
    ),
    FlavorItem(
      name: 'Lemon',
      imageUrl:
          'https://i.pinimg.com/736x/e7/33/46/e7334665a8bff0916d55db8533f18455.jpg',
    ),
    FlavorItem(name: 'No Flavor'),
  ];
}

