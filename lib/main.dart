import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
      ),
      home: ExpenseTrackerScreen(),
    );
  }
}

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  _ExpenseTrackerScreenState createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  final List<Map<String, dynamic>> _expenses = [];

  void _addExpense() {
    String title = _titleController.text;
    String amount = _amountController.text;

    if (title.isEmpty || amount.isEmpty) return;

    setState(() {
      _expenses.insert(0, {
        'title': title,
        'amount': double.parse(amount),
        'date': DateFormat.yMMMd().format(DateTime.now()),
      });
    });

    _titleController.clear();
    _amountController.clear();
    Navigator.pop(context);
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _showAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Expense",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Expense Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addExpense,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text("Add Expense", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  double get _totalExpenses {
    return _expenses.fold(0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text("Expense Tracker"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Animated Total Expense Display
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Total Expense",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "₹${_totalExpenses.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fade(duration: 500.ms).scale(delay: 300.ms),
              ],
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: _expenses.isEmpty
                ? Center(
                    child: Text(
                      "No Expenses Yet!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ).animate().fade(duration: 500.ms),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];

                      return Dismissible(
                        key: Key(expense['title']),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) => _deleteExpense(index),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade200,
                              child: Icon(Icons.attach_money, color: Colors.white),
                            ),
                            title: Text(expense['title']),
                            subtitle: Text("${expense['date']}"),
                            trailing: Text(
                              "₹${expense['amount']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ).animate().slideX(curve: Curves.easeOut, duration: 400.ms),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseSheet,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 28, color: Colors.white),
      ).animate().scale(delay: 300.ms).fade(duration: 500.ms),
    );
  }
}
