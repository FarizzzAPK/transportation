class TransportationSolver {
  final List<List<int>> costMatrix;
  final List<int> supply;
  final List<int> demand;

  TransportationSolver(this.costMatrix, this.supply, this.demand);

  List<List<int>> solve() {
    int m = costMatrix.length;
    int n = costMatrix[0].length;

    // Initialize allocation matrix
    List<List<int>> allocation = List.generate(m, (_) => List.filled(n, 0));
    List<int> remainingSupply = List.from(supply);
    List<int> remainingDemand = List.from(demand);

    // Allocate supply to meet demand using a greedy approach (North-West Corner Rule)
    int i = 0, j = 0;
    while (i < m && j < n) {
      int allocated = remainingSupply[i] < remainingDemand[j]
          ? remainingSupply[i]
          : remainingDemand[j];

      allocation[i][j] = allocated;
      remainingSupply[i] -= allocated;
      remainingDemand[j] -= allocated;

      if (remainingSupply[i] == 0) {
        i++;
      } else if (remainingDemand[j] == 0) {
        j++;
      }
    }

    return allocation;
  }
}
