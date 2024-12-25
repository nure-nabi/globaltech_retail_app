import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/widgets/text_form_forrmat.dart';

import '../../themes/themes.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'date_picker_state.dart';

class DatePickerWidget extends StatefulWidget {
  final Function onConfirm;
  const DatePickerWidget({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<DatePickerState>(context, listen: false).init();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DatePickerState>(
      builder: (context, state, child) {
        return Container(
          decoration: ContainerDecoration.decoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                color: primaryColor,
                child: const Center(
                  child: Text(
                    "Select Date",
                    style: TextStyle(
                      fontSize: 15.0,
                      wordSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          state.getFromDate = await MyDatePicker(context).englishDate();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: ContainerDecoration.decoration(
                              color: Colors.grey.shade100),
                          child: TextFieldFormat(
                            textFieldName: 'From Date',
                            textFormField: Container(
                              decoration: ContainerDecoration.decoration(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                child: Text(
                                  state.fromDate.replaceAll("-", "/"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: InkWell(
                          onTap: () async {
                            state.getToDate = await MyDatePicker(context).englishDate();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: ContainerDecoration.decoration(
                                color: Colors.grey.shade100),
                            child: TextFieldFormat(
                              textFieldName: 'To Date',
                              textFormField: Container(
                                decoration: ContainerDecoration.decoration(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: Text(
                                    state.toDate.replaceAll("-", "/"),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("CANCEL"),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onConfirm();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: const Text("CONFIRM"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
