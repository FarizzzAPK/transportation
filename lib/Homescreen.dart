import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  List<int> Row1 = List.filled(4, 0); // Row 1: Cost matrix + Supply
  List<int> Row2 = List.filled(4, 0); // Row 2: Cost matrix + Supply
  List<int> Row3 = List.filled(4, 0); // Row 3: Cost matrix + Supply
  List<int> Row4 = List.filled(4, 0); // Row 4: Demand

  // Function to calculate the solution using the Northwest Corner Rule
  Map<String, dynamic> northwestCornerSolution() {
    int supply1 = Row1[3];
    int supply2 = Row2[3];
    int supply3 = Row3[3];

    int demand1 = Row4[0];
    int demand2 = Row4[1];
    int demand3 = Row4[2];

    // Check if the problem is balanced
    int totalSupply = supply1 + supply2 + supply3;
    int totalDemand = demand1 + demand2 + demand3;

    if (totalSupply != Row4[3]||totalDemand != Row4[3]) {
      return {
        'error': true,
        'message': 'Please edit your values to be balanced.',
      };
    }

    // Apply the Northwest Corner Rule
    List<List<int>> solution = [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0]
    ];
    List<int> supply = [supply1, supply2, supply3];
    List<int> demand = [demand1, demand2, demand3];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (supply[i] == 0 || demand[j] == 0) continue;

        int allocation = supply[i] < demand[j] ? supply[i] : demand[j];
        solution[i][j] = allocation;
        supply[i] -= allocation;
        demand[j] -= allocation;
      }
    }

    // Calculate the minimum cost
    int minimumCost = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        minimumCost += solution[i][j] * [Row1, Row2, Row3][i][j];
      }
    }

    return {
      'error': false,
      'solution': solution,
      'minimumCost': minimumCost,
    };
  }

  // Function to show the solution in a dialog
  void showSolutionDialog(BuildContext context) {
    final result = northwestCornerSolution();

    if (result['error'] == true) {
      // Show error dialog if the problem is not balanced
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(result['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Show solution dialog if the problem is balanced
      final solution = result['solution'];
      final minimumCost = result['minimumCost'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Transportation Solution'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Solution Matrix:'),
                for (int i = 0; i < solution.length; i++)
                  Text(solution[i].toString()),
                SizedBox(height: 10),
                Text('Minimum Cost: $minimumCost'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Transportation',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Supply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
              for (int i = 0; i < 4; i++)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          i == 3 ? "Demand" : String.fromCharCode(65 + i),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: i == 3 ? 20 : 40,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (int j = 0; j < 4; j++)
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (val) {
                              if (i < 3) {
                                [Row1, Row2, Row3][i][j] = int.tryParse(val) ?? 0;
                              } else {
                                Row4[j] = int.tryParse(val) ?? 0;
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  showSolutionDialog(context);
                },
                child: Text("Solve"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
