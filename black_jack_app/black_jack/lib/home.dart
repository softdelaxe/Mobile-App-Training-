import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _deck = [];
  List<String> _playerHand = [];
  List<String> _dealerHand = [];
  int _playerScore = 0;
  int _dealerScore = 0;
  bool _isGameStarted = false;
  bool _isPlayerTurn = true;

  void _startGame() {
    setState(() {
      _deck = _generateDeck();
      _playerHand = _dealCards(_deck, 2);
      _dealerHand = _dealCards(_deck, 2);
      _playerScore = _calculateScore(_playerHand);
      _dealerScore = _calculateScore(_dealerHand);
      _isGameStarted = true;
      _isPlayerTurn = true;
    });
  }

  List<String> _generateDeck() {
    List<String> suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
    List<String> ranks = [
      'Ace',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'Jack',
      'Queen',
      'King'
    ];
    List<String> deck = [];
    for (var suit in suits) {
      for (var rank in ranks) {
        deck.add('$rank of $suit');
      }
    }
    return deck;
  }

  List<String> _dealCards(List<String> deck, int numCards) {
    List<String> hand = [];
    Random random = Random();
    for (var i = 0; i < numCards; i++) {
      int index = random.nextInt(deck.length);
      hand.add(deck[index]);
      deck.removeAt(index);
    }
    return hand;
  }

  int _calculateScore(List<String> hand) {
    int score = 0;
    int numAces = 0;
    for (var card in hand) {
      String rank = card.split(' of ')[0];
      if (rank == 'Ace') {
        numAces++;
        score += 11;
      } else if (rank == 'Jack' || rank == 'Queen' || rank == 'King') {
        score += 10;
      } else {
        score += int.parse(rank);
      }
    }
    while (score > 21 && numAces > 0) {
      score -= 10;
      numAces--;
    }
    return score;
  }

  void _hit() {
    if (_isPlayerTurn) {
      setState(() {
        _playerHand.add(_deck.removeLast());
        _playerScore = _calculateScore(_playerHand);

        if (_playerScore > 21) {
          _isPlayerTurn = false;
          _showGameOverDialog('Player busts! Dealer wins!');
        }
      });
    }
  }

  void _stand() {
    if (_isPlayerTurn) {
      setState(() {
        _isPlayerTurn = false;

        // Dealer's turn
        while (_dealerScore < 17) {
          _dealerHand.add(_deck.removeLast());
          _dealerScore = _calculateScore(_dealerHand);
        }

        // Evaluate the outcome
        if (_dealerScore > 21) {
          _showGameOverDialog('Dealer busts! Player wins!');
        } else if (_dealerScore < _playerScore) {
          _showGameOverDialog('Player wins!');
        } else if (_dealerScore > _playerScore) {
          _showGameOverDialog('Dealer wins!');
        } else {
          _showGameOverDialog('Push!');
        }
      });
    }
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.25; // 20% of screen width
    final cardHeight = size.height * 0.35; // 30% of screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blackjack'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isGameStarted
                  ? 'Player Score: $_playerScore'
                  : 'Press Start to begin',
              style: TextStyle(fontSize: size.width * 0.06),
            ),
            Text(
              _isGameStarted ? 'Dealer Score: $_dealerScore' : '',
              style: TextStyle(fontSize: size.width * 0.04),
            ),
            SizedBox(height: size.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _isGameStarted
                  ? _playerHand.map((card) {
                return Image.asset(
                  'assets/cards/${card.split(' of ')[0].toLowerCase()}_of_${card.split(' of ')[1].toLowerCase()}.png',
                  width: cardWidth,
                  height: cardHeight,
                );
              }).toList()
                  : [],
            ),
            SizedBox(height: size.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _isGameStarted
                  ? [
                Image.asset(
                  'assets/cards/${_dealerHand[0].split(' of ')[0].toLowerCase()}_of_${_dealerHand[0].split(' of ')[1].toLowerCase()}.png',
                  width: cardWidth,
                  height: cardHeight,
                ),
                Image.asset(
                  'assets/cards/back.png',
                  width: cardWidth,
                  height: cardHeight,
                ),
              ]
                  : [],
            ),
            SizedBox(height: size.height * 0.009),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isGameStarted ? _hit : null,
                  child: const Text('Hit'),
                ),
                ElevatedButton(
                  onPressed: _isGameStarted ? _stand : null,
                  child: const Text('Stand'),
                ),
                ElevatedButton(
                  onPressed: _isGameStarted ? null : _startGame,
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
