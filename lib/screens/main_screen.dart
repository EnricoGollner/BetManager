import 'package:audioplayers/audioplayers.dart';
// import 'package:bet_manager_app/controllers/filter_controller.dart';
import 'package:bet_manager_app/controllers/transaction_controller.dart';
import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:bet_manager_app/core/utils/formatter.dart';
import 'package:bet_manager_app/core/utils/validator.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:bet_manager_app/screens/widgets/custom_transaction_card.dart';
import 'package:bet_manager_app/screens/widgets/register_form.dart';
import 'package:bet_manager_app/screens/widgets/week_transaction_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  // final TextEditingController _initialDateController = TextEditingController();
  // final TextEditingController _finalDateController = TextEditingController();

  late TransactionController _transactionController;
  // late FilterController _filterController;


  @override
  void initState() {
    // _filterController = context.read<FilterController>();


    WidgetsBinding.instance.addPostFrameCallback((_) async => await _transactionController.getTransactions());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _transactionController = context.watch<TransactionController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildDateRange(),
            SizedBox(height: 30.s),
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 38),
                    Expanded(
                      child: Consumer<TransactionController>(
                        builder: (_, __, ___) {
                        return WeekTransactionChart(
                          weekDays: _transactionController.weekTransactions,
                        );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                  child: Consumer<TransactionController>(
                    builder: (_, __, ___) => _buildTransactionsList()
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _showDialogNewTransaction,
        child: const Icon(Icons.add, color: surfaceColor),
      ),
    );
  }

  ExpansionPanelList _buildTransactionsList() {
    return ExpansionPanelList(
      expandedHeaderPadding: const EdgeInsets.all(0),
      expandIconColor: bodyTextColor4,
      expansionCallback: (panelIndex, isExpanded) {
        setState(()=>  _transactionController.weekTransactions[panelIndex].isExpanded = isExpanded);
      },
      children:  _transactionController.weekTransactions.map<ExpansionPanel>((weekDayExpansel) {
        return ExpansionPanel(
            isExpanded: weekDayExpansel.isExpanded,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                splashColor: Colors.transparent,
                onTap: () => setState(()=> weekDayExpansel.isExpanded = !isExpanded),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatter.formatDatetime(weekDayExpansel.date),
                      style: const TextStyle(color: bodyTextColor4),
                    ),
                  Text(
                    weekDayExpansel.transactions.length.toString(),
                    style: const TextStyle(fontSize: 14, color: bodyTextColor4),
                  ),
                  ],
                ),
              );
            },
            body: _buildListTransactionPerDay(weekDayExpansel.date),
          );
        }).toList(),
      );
  }

  Widget _buildListTransactionPerDay(DateTime date) {
    final List<Transaction> dayTransactions = _transactionController.transactions.where(
      (transaction) => Validator.verifyDate(transaction.date, compareTo: date),
    ).toList();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 5),
      itemCount: dayTransactions.length,
      itemBuilder: (_, index) {
        final Transaction transaction = _transactionController.transactions[index];
        return CustomTransactionCard(transaction);
      },
    ); 
  }

  // Widget _buildDateRange() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: 10.s),
  //     child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Expanded(
  //               child: CustomDateTextField(
  //                 labelText: 'From:',
  //                 selectDate: () async => await _pickDateTime(isInitial: true),
  //                 controller: _finalDateController,
  //                 prefixIcon: Icons.today,
  //               ),
  //             ),
  //             const SizedBox(width: 10),
  //             Expanded(
  //               child: CustomDateTextField(
  //                 labelText: 'To:',
  //                 selectDate: () async => await _pickDateTime(),
  //                 controller: _initialDateController,
  //                 prefixIcon: Icons.event,
  //               ),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  Row _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _makeTransactionsIcon(),
        const SizedBox(width: 38),
        const Text(
          'Week Transactions',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  //   Future<void> _pickDateTime({bool isInitial = true}) async {
  //   final DateTime? pickedDateTime = await showDatePicker(
  //     context: context,
  //     locale: const Locale('pt', 'BR'),
  //     initialDate: isInitial ? _filterController.initialDate : _filterController.finalDate,
  //     firstDate: DateTime(2024),
  //     lastDate: DateTime.now(),
  //     selectableDayPredicate: isInitial
  //         ? (DateTime day) => day.isBefore(_filterController.finalDate)
  //         : (DateTime day) => day.isAfter(_filterController.initialDate),
  //   );

  //   if (pickedDateTime != null) {
  //     if (isInitial) {
  //       _filterController.setInitialDate(pickedDateTime);
  //       _initialDateController.text = Formatter.formatDatetime(pickedDateTime);
  //     } else {
  //       _filterController.setFinalDate(pickedDateTime);
  //       _finalDateController.text = Formatter.formatDatetime(pickedDateTime);
  //     }
  //   }
  // }

  void _showDialogNewTransaction() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return RegisterForm(
          registerTransaction: registerTransaction,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> registerTransaction(bool isIncome, {required String amountText}) async {
    if (isIncome) await _playIncomeSound();

    _transactionController.addTransaction(
      amount: Formatter.currencyToDouble(amountText),
      type: isIncome ? TransactionType.income : TransactionType.deposit,
    );
    if (mounted) Navigator.pop(context);
  }
  
  Future<void> _playIncomeSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource('sounds/money.mp3'));
  }
}
