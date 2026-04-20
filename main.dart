import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedule_resolver/services/ai_schedule_service.dart';
import 'providers/schedule_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        // Fixed: Class name was AiScheduleAnalysis in your service file
        ChangeNotifierProvider(create: (_) => AiScheduleAnalysis()),
      ],
      child: const ScheduleResolverApp(),
    ),
  );
}

// Fixed: StatelessWidget (lowercase 'l')
class ScheduleResolverApp extends StatelessWidget {
  // Fixed: Correct constructor syntax () instead of {{}}
  const ScheduleResolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Resolver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Fixed: ColorScheme.fromSeed (Correct spelling and camelCase)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Fixed: useMaterial3 (Correct spelling)
        useMaterial3: true,
        // Fixed: interTextTheme (Corrected GoogleFont name and method)
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const DashboardScreen(),
    );
  }
}