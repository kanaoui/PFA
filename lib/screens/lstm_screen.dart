import 'package:flutter/material.dart';
import '../services/lstm_service.dart';
import 'dart:math';


class LSTMScreen extends StatefulWidget {
  const LSTMScreen({super.key});

  @override
  State<LSTMScreen> createState() => _LSTMScreenState();
}

class _LSTMScreenState extends State<LSTMScreen> {
  final LSTMService _lstmService = LSTMService();
  final TextEditingController _pricesController = TextEditingController();

  bool _isProcessing = false;
  Map<String, dynamic>? _result;

  List<double> _generateRandomPrices({
  int length = 60, // MUST be 60
  double startPrice = 150,
  }) {
  final random = Random();
  final prices = <double>[];

  double current = startPrice;

  for (int i = 0; i < length; i++) {
    final change = (random.nextDouble() * 4 - 2) / 100; // -2% → +2%
    current += current * change;
    prices.add(double.parse(current.toStringAsFixed(2)));
  }

  return prices;
  }

  Future<void> _predict() async {
    setState(() => _isProcessing = true);

    try {
      // Parse prices from text input
      List<String> priceStrings = _pricesController.text.split(',');
      List<double> prices = priceStrings
          .map((s) => double.tryParse(s.trim()))
          .where((p) => p != null)
          .cast<double>()
          .toList();

      if (prices.length < 10) {
        throw 'Please enter at least 10 price values';
      }

      final result = await _lstmService.predictStockTrend(prices);
      setState(() {
        _result = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E7), Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trend Forecasting',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            'Predictive Analytics Engine',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF16A34A).withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'LSTM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF22C55E),
                                    Color(0xFF16A34A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Input historical price data separated by commas or load sample dataset',
                                style: TextStyle(
                                  color: Color(0xFF16A34A),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Input Field
                      const Text(
                        'Price History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF22C55E).withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _pricesController,
                          maxLines: 5,
                          style: const TextStyle(color: Color(0xFF15803D)),
                          decoration: InputDecoration(
                            hintText: 'e.g., 150.0, 152.5, 151.0, 153.2...',
                            hintStyle: TextStyle(color: const Color(0xFF22C55E).withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                      onPressed: () {
                                        final prices = _generateRandomPrices(length: 60);
                                        _pricesController.text = prices.join(', ');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF15803D),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        side: const BorderSide(
                                          color: Color(0xFF22C55E),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Text('Randomize Data'),
                                    ),

                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF22C55E),
                                    Color(0xFF16A34A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF22C55E,
                                    ).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _isProcessing ? null : _predict,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Generate Forecast',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Results
                      if (_result != null) ...[
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _result!['prediction'] == 'Buy'
                                  ? [
                                      const Color(0xFF22C55E),
                                      const Color(0xFF16A34A),
                                    ]
                                  : _result!['prediction'] == 'Sell'
                                  ? [
                                      const Color(0xFFDC2626),
                                      const Color(0xFFB91C1C),
                                    ]
                                  : [
                                      const Color(0xFF16A34A),
                                      const Color(0xFF15803D),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_result!['prediction'] == 'Buy'
                                            ? const Color(0xFF22C55E)
                                            : _result!['prediction'] == 'Sell'
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF16A34A))
                                        .withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _result!['prediction'] == 'Buy'
                                    ? Icons.trending_up_rounded
                                    : _result!['prediction'] == 'Sell'
                                    ? Icons.trending_down_rounded
                                    : Icons.trending_flat_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _result!['prediction'],
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Confidence: ${_result!['confidence'].toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                                  Text(
  'Predicted next value: ${_result!['predictedValue'].toStringAsFixed(2)}',
  style: TextStyle(
    fontSize: 14,
    color: Colors.white.withOpacity(0.9),
    fontWeight: FontWeight.w500,
  ),
),
                                  Text(
                                    'Last known value: ${_result!['lastValue'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _result!['recommendations'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // All Predictions
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Analysis Breakdown',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ...(_result!['allPredictions']
                                      as Map<String, double>)
                                  .entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildPredictionBar(
                                        entry.key,
                                        entry.value,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionBar(String label, double confidence) {
    Color color = label == 'Buy'
        ? const Color(0xFF22C55E)
        : label == 'Sell'
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF15803D),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${confidence.toStringAsFixed(1)}%',
              style: const TextStyle(color: Color(0xFF16A34A), fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: const Color(0xFFE8F5E9),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pricesController.dispose();
    _lstmService.dispose();
    super.dispose();
  }
}
