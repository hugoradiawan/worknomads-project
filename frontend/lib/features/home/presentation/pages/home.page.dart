import 'package:flutter/material.dart'
    show
        AppBar,
        FloatingActionButton,
        IconButton,
        Icons,
        Scaffold,
        CircularProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/presentation/blocs/homepage.cubit.dart';
import 'package:frontend/features/home/presentation/blocs/homepage.state.dart';
import 'package:frontend/features/home/presentation/components/image_tile.component.dart'
    show ImageTile;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(_) => BlocProvider(
    create: (_) => HomePageCubit(),
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          BlocBuilder<HomePageCubit, HomePageState>(
            buildWhen: (_, _) => false,
            builder: (context, _) => IconButton(
              onPressed: BlocProvider.of<HomePageCubit>(context).logout,
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: BlocSelector<HomePageCubit, HomePageState, List<MediaModel>>(
        selector: (state) => state.mediaList,
        builder: (context, mediaList) {
          if (mediaList.isNotEmpty) {
            return ListView(
              children: mediaList
                  .map((media) => ImageTile(media: media))
                  .toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocBuilder<HomePageCubit, HomePageState>(
        buildWhen: (_, _) => false,
        builder: (context, _) => FloatingActionButton(
          onPressed: () =>
              BlocProvider.of<HomePageCubit>(context).showMediaOptions(context),
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    ),
  );
}
