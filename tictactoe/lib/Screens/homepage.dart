import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var grid = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  var winner = "";
  var currentplayer = 'X';
  bool isGameOver = false; // Add this variable to track game over status

  void showSnackBarMessage(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        duration: Duration(
            days: 1), // Set a long duration to keep the snackbar visible
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void drawxo(i) {
    if (!isGameOver && grid[i] == '') {
      setState(() {
        grid[i] = currentplayer;
        currentplayer = currentplayer == 'X' ? 'O' : 'X';
      });

      findWinner(grid[i]);

      if (winner != '') {
        isGameOver = true; // Set the game over flag when a winner is found
        // Show green Snackbar for win
        showSnackBarMessage('$winner won the game', Colors.green);
      } else if (winner.isEmpty && !grid.contains('')) {
        isGameOver = true; // Set the game over flag for a draw
        // Show red Snackbar for draw
        showSnackBarMessage("It's a draw!", Colors.red);
      }
    }
  }

  bool checkMove(i1, i2, i3, sign) {
    if (grid[i1] == sign && grid[i2] == sign && grid[i3] == sign) {
      return true;
    }
    return false;
  }

  void findWinner(currentsign) {
    if (checkMove(0, 1, 2, currentsign) ||
            checkMove(3, 4, 5, currentsign) ||
            checkMove(6, 7, 8, currentsign) || //rows
            checkMove(0, 3, 6, currentsign) ||
            checkMove(1, 4, 7, currentsign) ||
            checkMove(2, 5, 8, currentsign) || //columns
            checkMove(0, 4, 8, currentsign) ||
            checkMove(2, 4, 6, currentsign) //diagonal
        ) {
      setState(() {
        winner = currentsign;
      });
    }
  }

  void reset() {
    setState(() {
      isGameOver = false; // Reset the game over flag
      winner = "";
      grid = [
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Tic Tac Toe',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
              margin: const EdgeInsets.all(20),
              color: Colors.black,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: grid.length,
                itemBuilder: (context, index) => Material(
                  color: Colors.grey,
                  child: InkWell(
                    splashColor: Colors.black,
                    onTap: () => drawxo(index),
                    child: Center(
                      child: Text(
                        grid[index],
                        style: const TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: reset,
              icon: Icon(
                Icons.refresh,
                color: Colors.grey.shade800,
              ),
              label: const Text(
                'play again',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
