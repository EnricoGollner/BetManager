import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:bet_manager_app/core/utils/formatter.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:flutter/material.dart';

class CustomTransactionCard extends StatelessWidget {
  final Transaction transaction;
  
  const CustomTransactionCard(this.transaction, {super.key});
  
  @override
  Widget build(BuildContext context) {
    bool isIncome = transaction.type == TransactionType.income; 

    return Card(
      color: surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isIncome ? incomeBackgroundColor : primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(isIncome ?  Icons.attach_money : Icons.account_balance_wallet),
            ),
            SizedBox(width: 20.s),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Valor: ', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(Formatter.doubleToCurrency(transaction.amount)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(Formatter.formatDatetime(transaction.date), style: const TextStyle(color: bodyTextColor3),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}