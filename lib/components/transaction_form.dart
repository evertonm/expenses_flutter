import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key, this.onSubmit});

  final void Function(String, double, DateTime)? onSubmit;

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;
    if (title.isEmpty || value <= 0 || _selectedDate == null) return;
    widget.onSubmit!(title, value, _selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Valor R\$'),
              ),
              LayoutBuilder(builder: (ctx, constraints) {
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'Nenhuma data selecionada!'
                            : DateFormat('dd/MM/y').format(_selectedDate!)),
                      ),
                      TextButton(
                        onPressed: _showDatePicker,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            foregroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: const Text(
                          'Selecionar data',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: const Text(
                        'Nova transação',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
