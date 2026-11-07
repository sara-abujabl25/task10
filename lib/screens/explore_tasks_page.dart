
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/online_task_cubit.dart';
import '../cubit/online_task_state.dart';
import '../models/online_task_model.dart';

class ExploreTasksPage extends StatefulWidget {
  const ExploreTasksPage({super.key});

  @override
  State<ExploreTasksPage> createState() => _ExploreTasksPageState();
}

class _ExploreTasksPageState extends State<ExploreTasksPage> {
  late final PageController _pageController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.88,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextQuote(int length) {
    final nextIndex = (currentIndex + 1) % length;

    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void previousQuote(int length) {
    final previousIndex =
        (currentIndex - 1 + length) % length;

    _pageController.animateToPage(
      previousIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F5),
        elevation: 0,
        title: const Text(
          'Daily Inspiration',
          style: TextStyle(
            color: Color(0xFF344B39),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF344B39),
            ),
            onPressed: () {
              setState(() {
                currentIndex = 0;
              });

              _pageController.jumpToPage(0);

              context.read<OnlineTaskCubit>().fetchTasks();
            },
          ),
        ],
      ),
      body: BlocBuilder<OnlineTaskCubit, OnlineTaskState>(
        builder: (context, state) {
          if (state is OnlineTaskLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF64866A),
              ),
            );
          }

          if (state is OnlineTaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off_rounded,
                    size: 55,
                    color: Color(0xFF9A9A9A),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Oops! Something went wrong.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OnlineTaskCubit>().fetchTasks();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is OnlineTaskSuccess) {
            final quotes = state.tasks;

            if (quotes.isEmpty) {
              return const Center(
                child: Text('No inspiration available yet.'),
              );
            }

            if (currentIndex >= quotes.length) {
              currentIndex = 0;
            }

            return Column(
              children: [
                const SizedBox(height: 12),

                const Text(
                  'A little inspiration goes a long way ✨',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                  ),
                ),

                if (state.isFromCache)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0E8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Showing saved inspiration offline.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF48634D),
                        ),
                      ),
                    ),
                  ),

                Expanded(
                  child: Center(
                    child: SizedBox(
                      height: 410,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: quotes.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            child: _buildQuoteCard(
                              quotes[index],
                              index,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentIndex + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64866A),
                      ),
                    ),
                    Text(
                      ' / ${quotes.length}',
                      style: const TextStyle(
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        previousQuote(quotes.length);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                      color: const Color(0xFF64866A),
                    ),

                    const SizedBox(width: 18),

                    const Text(
                      'Swipe or tap to explore',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 18),

                    IconButton(
                      onPressed: () {
                        nextQuote(quotes.length);
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 19,
                      ),
                      color: const Color(0xFF64866A),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
              ],
            );
          }

          return const Center(
            child: Text('No inspiration available.'),
          );
        },
      ),
    );
  }

  Widget _buildQuoteCard(
    QuoteModel quote,
    int index,
  ) {
    final colors = [
      const Color(0xFFFFE9A8),
      const Color(0xFFE7F0E8),
      const Color(0xFF536B79),
      const Color(0xFFEDE5F7),
    ];

    final textColors = [
      const Color(0xFF594728),
      const Color(0xFF344B39),
      Colors.white,
      const Color(0xFF594A67),
    ];

    final icons = [
      Icons.wb_sunny_rounded,
      Icons.eco_rounded,
      Icons.nightlight_round,
      Icons.favorite_rounded,
    ];

    final labels = [
      'A NEW DAY, A NEW CHANCE',
      'GROW AT YOUR OWN PACE',
      'DREAM BIG',
      'CHOOSE HAPPINESS',
    ];

    final accentColors = [
      const Color(0xFFB98732),
      const Color(0xFF52765A),
      const Color(0xFFF5DDA0),
      const Color(0xFF9878AD),
    ];

    final colorIndex = index % 4;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors[colorIndex],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors[colorIndex].withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[colorIndex],
            size: 43,
            color: accentColors[colorIndex],
          ),

          const SizedBox(height: 20),

          Text(
            labels[colorIndex],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              color: textColors[colorIndex].withOpacity(0.75),
            ),
          ),

          const SizedBox(height: 25),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  '“${quote.quote}”',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    height: 1.6,
                    fontWeight: FontWeight.w600,
                    color: textColors[colorIndex],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            width: 45,
            height: 2,
            decoration: BoxDecoration(
              color: accentColors[colorIndex],
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            '— ${quote.author}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColors[colorIndex],
            ),
          ),

          const SizedBox(height: 12),

          IconButton(
            tooltip: 'Copy quote',
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: '"${quote.quote}" — ${quote.author}',
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quote copied!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: Icon(
              Icons.copy_rounded,
              color: textColors[colorIndex],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
