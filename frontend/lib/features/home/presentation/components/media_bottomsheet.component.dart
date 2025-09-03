import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        EdgeInsets,
        MainAxisAlignment,
        CrossAxisAlignment,
        Icons,
        Icon,
        Text,
        Column,
        AspectRatio,
        Card,
        Expanded,
        TextAlign,
        Row,
        Padding,
        SizedBox,
        InkWell;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, BlocBuilder;
import 'package:frontend/features/home/presentation/blocs/media_bottomsheet/media_bottomsheet.cubit.dart'
    show MediaBottomSheetCubit;
import 'package:frontend/features/home/presentation/blocs/media_bottomsheet/media_bottomsheet.state.dart'
    show MediaBottomSheetState;

class MediaBottomSheet extends StatelessWidget {
  const MediaBottomSheet({super.key});

  @override
  Widget build(_) => BlocProvider<MediaBottomSheetCubit>(
    create: (_) => MediaBottomSheetCubit(),
    child: SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: AspectRatio(
                  aspectRatio: 1,
                  child:
                      BlocBuilder<MediaBottomSheetCubit, MediaBottomSheetState>(
                        buildWhen: (_, _) => false,
                        builder: (context, _) => InkWell(
                          onTap: () => BlocProvider.of<MediaBottomSheetCubit>(
                            context,
                          ).pickAudio(context),
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.mic),
                              Text('Pick audio'),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: AspectRatio(
                  aspectRatio: 1,
                  child:
                      BlocBuilder<MediaBottomSheetCubit, MediaBottomSheetState>(
                        buildWhen: (_, _) => false,
                        builder: (context, _) => InkWell(
                          onTap: () => BlocProvider.of<MediaBottomSheetCubit>(
                            context,
                          ).takePhoto(context),
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt),
                              Text('Take Photo'),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: AspectRatio(
                  aspectRatio: 1,
                  child:
                      BlocBuilder<MediaBottomSheetCubit, MediaBottomSheetState>(
                        buildWhen: (_, _) => false,
                        builder: (context, _) => InkWell(
                          onTap: () => BlocProvider.of<MediaBottomSheetCubit>(
                            context,
                          ).pickFromGallery(context),
                          child: Column(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo),
                              Text(
                                'Pick from Gallery',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
