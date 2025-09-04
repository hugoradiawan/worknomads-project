import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BorderRadius, Image, BoxFit, ClipRRect, Card;
import 'package:frontend/core/blocs/http_client/http_client.bloc.dart';
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;

class ImageTile extends StatelessWidget {
  const ImageTile({super.key, required this.media});

  final MediaModel media;

  @override
  Widget build(_) => Card(
    elevation: 1,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        '${HttpBloc.i!.client.options.baseUrl}media/${media.id}/',
        headers: {
          if (HttpBloc.i?.state.token?.accessToken != null)
            'Authorization': 'Bearer ${HttpBloc.i!.state.token?.accessToken}',
        },
        fit: BoxFit.fitHeight,
      ),
    ),
  );
}
