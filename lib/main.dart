import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';
import 'pages/home.dart';
import 'pages/movie_list.dart';
import 'pages/movie_viewer.dart';
import'package:localstorage/localstorage.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.yellowAccent,
    brightness: Brightness.dark
  )
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatefulWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedPageIndex = 0;
  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider(localStorage))
      ],
      child: MaterialApp(
        theme: darkTheme,
        title: 'Movie Up',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: [
            Center(
              child: HomeScreen(),
            ),
            Center(
              child: MovieListScreen(),
            )
          ][selectedPageIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedPageIndex = index;
                });
              },
              destinations: const <NavigationDestination>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.play_circle),
                  icon: Icon(Icons.play_circle_outline),
                  label: 'Find a movie',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.list),
                  icon: Icon(Icons.list_outlined),
                  label: 'Movie List',
                ),
              ]
          ),
        ),
      ),
    );
  }
}