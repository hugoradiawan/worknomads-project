import 'package:flutter/material.dart'
    show
        AppBar,
        FloatingActionButton,
        IconButton,
        Icons,
        Scaffold,
        CircularProgressIndicator,
        RefreshIndicator,
        CustomScrollView,
        SliverFillRemaining;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/home/data/models/media.model.dart'
    show MediaModel;
import 'package:frontend/features/home/domain/params/upload_media.params.dart'
    show MediaUploadType;
import 'package:frontend/features/home/presentation/blocs/homepage.cubit.dart';
import 'package:frontend/features/home/presentation/blocs/homepage.state.dart';
import 'package:frontend/features/home/presentation/components/image_tile.component.dart'
    show ImageTile;
import 'package:frontend/features/home/presentation/components/voice_tile.component.dart'
    show VoiceTile;

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
      body: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          if (state is HomePageLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<HomePageCubit>(context).loadMedia();
              },
              child: const CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<HomePageCubit>(context).loadMedia();
            },
            child: ListView.builder(
              itemCount: state.mediaList.length,
              itemBuilder: (_, index) {
                final int reversedIndex = state.mediaList.length - index - 1;
                final MediaModel media = state.mediaList[reversedIndex];
                return switch (media.mediaType) {
                  MediaUploadType.image => ImageTile(media: media),
                  MediaUploadType.audio => VoiceTile(media: media),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          );
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
