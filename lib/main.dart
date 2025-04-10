import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MovableDock(),
  ));
}

class MovableDock extends StatefulWidget {
  const MovableDock({super.key});

  @override
  State<MovableDock> createState() => _MovableDockState();
}

class _MovableDockState extends State<MovableDock> {
  int? draggingIndex;

  List<IconData> dockItems = [
    Icons.settings,
    Icons.music_note,
    Icons.access_alarm_rounded,
    Icons.search,
    Icons.headphones,
    Icons.call,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      // Align the dock at the bottom-center of the screen.
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // Height of the row that holds the draggable buttons.
          height: 120,
          // Set a background color for the row.
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // Generate buttons based on the `dockItems` list.
              children: List.generate(dockItems.length, (index) {
                // Get each item from the list based on its index.
                final icon = dockItems[index];
                return DragTarget<int>(
                  // Prevent the item from being dropped on itself.
                  onWillAcceptWithDetails: (details) => details.data != index,
                  // Handle the item being accepted (i.e., dropped).
                  onAcceptWithDetails: (DragTargetDetails<int> details) {
                    // Get the index of the item being dragged
                    final fromIndex = details.data;
                    // Update the items list by moving the dragged item
                    setState(() {
                      final moved = dockItems.removeAt(fromIndex);
                      dockItems.insert(index, moved);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isDragging = draggingIndex == index;
                    final scale = candidateData.isNotEmpty ? 1.3 : 1.0;

                    return AnimatedScale(
                      scale: isDragging ? 0.8 : scale,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      child: Draggable<int>(
                        data: index,
                        onDragStarted: () => setState(() {
                          draggingIndex = index;
                        }),
                        onDragEnd: (_) => setState(() {
                          draggingIndex = null;
                        }),
                        feedback: Icon(
                          icon,
                          color: Colors.white38,
                          size: 60,
                        ),
                        childWhenDragging:
                            const SizedBox(width: 60, height: 60),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
