import 'package:bet_manager_app/controllers/filter_controller.dart';
import 'package:bet_manager_app/controllers/transaction_controller.dart';
import 'package:bet_manager_app/core/theme/colors.dart';
import 'package:bet_manager_app/core/theme/ui_responsivity.dart';
import 'package:bet_manager_app/core/utils/formatter.dart';
import 'package:bet_manager_app/models/transaction.dart';
import 'package:bet_manager_app/screens/widgets/box_icon.dart';
import 'package:bet_manager_app/screens/widgets/custom_primary_button.dart';
import 'package:bet_manager_app/screens/widgets/custom_date_text_field.dart';
import 'package:bet_manager_app/screens/widgets/custom_text_field.dart';
import 'package:bet_manager_app/screens/widgets/custom_transaction_card.dart';
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

  final TextEditingController _initialDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();

  late TransactionController _transactionController;
  late FilterController _filterController;

  @override
  void initState() {
    _filterController = context.read<FilterController>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _transactionController.getRecentTransactions());

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
                          return WeekTransactionChart(recentTransactions: _transactionController.weekTransactions);
                        }
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<TransactionController>(
                builder: (context, value, child) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 5),
                  itemCount: _transactionController.transactions.length,
                  itemBuilder: (context, index) {
                    final Transaction transaction = _transactionController.transactions[index];
                    return CustomTransactionCard(transaction);
                  },
                );
              }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _showDialogNewTransaction,
        child: const Icon(Icons.add, color: bodyTextColor3),
      ),
    );
  }

  Widget _buildDateRange() {
    return Padding(
      padding: EdgeInsets.only(top: 10.s),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomDateTextField(
                  labelText: 'From:',
                  selectDate: () async => await _pickDateTime(isInitial: true),
                  controller: _finalDateController,
                  prefixIcon: Icons.today,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomDateTextField(
                  labelText: 'To:',
                  selectDate: () async => await _pickDateTime(),
                  controller: _initialDateController,
                  prefixIcon: Icons.event,
                ),
              ),
            ],
          ),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _makeTransactionsIcon(),
        const SizedBox(width: 38),
        const Text(
          'Transactions',
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

    Future<void> _pickDateTime({bool isInitial = true}) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: isInitial ? _filterController.initialDate : _filterController.finalDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      selectableDayPredicate: isInitial
          ? (DateTime day) => day.isBefore(_filterController.finalDate)
          : (DateTime day) => day.isAfter(_filterController.initialDate),
    );

    if (pickedDateTime != null) {
      if (isInitial) {
        _filterController.setInitialDate(pickedDateTime);
        _initialDateController.text = Formatter.formatDatetime(pickedDateTime);
      } else {
        _filterController.setFinalDate(pickedDateTime);
        _finalDateController.text = Formatter.formatDatetime(pickedDateTime);
      }
    }
  }

  void _showDialogNewTransaction() {
    final TextEditingController ctrlAmount = TextEditingController();
    bool isIncome = true;

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20.s),
                          height: 400.s,
                          width: 300.s,
                          decoration: BoxDecoration(
                            color: bodyTextColor3,
                            borderRadius: BorderRadius.circular(20.s),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Novo Registro',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                    splashRadius: 20.s,
                                    icon: const BoxIcon(
                                      iconData: Icons.close,
                                      color: backgroundColor,
                                    ),
                                    onPressed: () {
                                      ctrlAmount.clear();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 20.s),
                                  SizedBox(
                                    width: 100.s,
                                    child: CustomTextField(
                                        autofocus: true,
                                        controller: ctrlAmount,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        label: 'Valor:',
                                        hintText: 'Insira o valor do registro...',
                                        enableButtonCleanValue: true,
                                      ),
                                  ),
                                  SizedBox(height: 20.s),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ChoiceChip(
                                            selected: isIncome,
                                            selectedColor: incomeBackgroundColor,
                                            label: Text('Ganhos', style: TextStyle(color: isIncome ? bodyTextColor3 : bodyTextColor5),),
                                            onSelected: (newValue) {
                                              setState(() {
                                                if (isIncome) return;
                                                isIncome = true;
                                              });
                                            },
                                          ),
                                          SizedBox(width: 15.s),
                                          ChoiceChip(
                                            selected: !isIncome,
                                            selectedColor: primaryColor,
                                            label: const Text('Depósito'),
                                            onSelected: (newValue) {
                                              setState(() {
                                                if (!isIncome) return;
                                                isIncome = false;
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                  SizedBox(height: 20.s),
                                  CustomPrimaryButton(
                                    isLoading: false,
                                    text: 'SALVAR',
                                    onPressed: () {
                                      _transactionController.addTransaction(
                                        value: Formatter.currencyToDouble(ctrlAmount.text),
                                        type: isIncome ? TransactionType.income : TransactionType.deposit,
                                      );
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
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
}
