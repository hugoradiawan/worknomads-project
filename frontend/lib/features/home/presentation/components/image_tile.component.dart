import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BorderRadius, Image, BoxFit, ClipRRect, Card;

class ImageTile extends StatelessWidget {
  const ImageTile({super.key});

  @override
  Widget build(_) => Card(
    elevation: 1,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        'https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4',
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}
