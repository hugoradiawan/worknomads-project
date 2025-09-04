import 'package:flutter/material.dart'
    show StatelessWidget, Widget, Icon, Icons, Slider, ListTile, Card;
import 'package:frontend/features/home/data/models/media.model.dart' show MediaModel;

class VoiceTile extends StatelessWidget {
  const VoiceTile({super.key, required this.media});

  final MediaModel media;

  @override
  Widget build(_) => Card(
    elevation: 1,
    child: ListTile(
      leading: const Icon(Icons.play_arrow),
      title: Slider(value: 0.5, onChanged: (value) {}),
    ),
  );
}
