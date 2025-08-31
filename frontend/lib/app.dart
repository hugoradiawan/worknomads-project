import 'package:flutter/material.dart'
    show StatelessWidget, Widget, ColorScheme, Colors, ThemeData, MaterialApp;
import 'package:frontend/core/widgets/infrastructure_provider.dart'
    show InfrastructureProvider;
import 'package:frontend/features/login/presentation/pages/login.page.dart'
    show LoginPage;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(_) => InfrastructureProvider(
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
    ),
  );
}
