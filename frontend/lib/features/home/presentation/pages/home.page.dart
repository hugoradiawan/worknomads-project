import 'package:flutter/material.dart'
    show
        AppBar,
        Card,
        FloatingActionButton,
        IconButton,
        Icons,
        ListTile,
        Scaffold,
        Slider,
        showModalBottomSheet;
import 'package:flutter/widgets.dart';
import 'package:frontend/shared/blocs/user.bloc.dart';
import 'package:frontend/shared/blocs/user.event.dart' show LogoutUser;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Home Page'),
      actions: [IconButton(onPressed: () {
        UserBloc.i.add(LogoutUser());
      }, icon: const Icon(Icons.logout))],
    ),
    body: ListView(
      children: [
        Card(
          elevation: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Card(
          elevation: 1,
          child: ListTile(
            leading: const Icon(Icons.play_arrow),
            title: Slider(value: 0.5, onChanged: (value) {}),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(Icons.mic),
                            Text('Record audio'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: AspectRatio(
                        aspectRatio: 1,
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
                  Expanded(
                    child: Card(
                      child: AspectRatio(
                        aspectRatio: 1,
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
                ],
              ),
            ),
          ),
        );
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    ),
  );
}
