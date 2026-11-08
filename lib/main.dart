
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/explore_tasks_page.dart';
import 'screens/login_page.dart';

import 'cubit/task_cubit.dart';
import 'cubit/online_task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://dllnzseaqspxsudbomno.supabase.co",
    publishableKey: "sb_publishable_Hr9HixE9y8_m5nvyBl46lw_y3d8NvYi",
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(),
        ),
        BlocProvider(
          create: (context) => OnlineTaskCubit()..fetchTasks(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF52745B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F2),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const MainPage();
        }

        return const LoginPage();
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<TaskCubit>().loadTasks();
  }

  final List<Widget> pages = const [
    HomePage(),
    ExploreTasksPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE2EBDF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
