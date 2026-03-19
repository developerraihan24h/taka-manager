import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takamanager/l10n/app_localizations.dart';

import '../../uihelper.dart';
import '../viewmodels/account_provider.dart';

class Addaccount extends StatefulWidget {
  final Map<String, dynamic>? account; // ✅ optional

  const Addaccount({super.key, this.account});

  @override
  State<Addaccount> createState() => _AddaccountState();
}

class _AddaccountState extends State<Addaccount> {
  TextEditingController EnterAccountNameController = TextEditingController();
  TextEditingController EnterHolderNameController = TextEditingController();
  TextEditingController EnterAmountController = TextEditingController();
  TextEditingController AccountNumberController = TextEditingController();

  bool isEdit = false; // ✅ track mode

  @override
  void initState() {
    super.initState();

    // ✅ If account is passed → Edit mode
    if (widget.account != null) {
      isEdit = true;

      EnterAccountNameController.text =
      widget.account!['account_name'];
      EnterHolderNameController.text =
      widget.account!['holder_name'];
      EnterAmountController.text =
          widget.account!['balance'].toString();
      AccountNumberController.text =
      widget.account!['account_number'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        title: uiHelper.CustomText(
          text: isEdit ? AppLocalizations.of(context)!.update_account : AppLocalizations.of(context)!.add_account,
          fontSize: 24,
          fontweight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),

            uiHelper.customTextFieldCommon(
              controller: EnterAccountNameController,
              text: "Enter Account Name",
              labelText: AppLocalizations.of(context)!.account_name,
              tohide: false,
              textinputtype: TextInputType.text,
            ),

            SizedBox(height: 10),

            uiHelper.customTextFieldCommon(
              controller: EnterHolderNameController,
              text: "Enter Name",
              labelText: AppLocalizations.of(context)!.your_name,
              tohide: false,
              textinputtype: TextInputType.text,
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: uiHelper.customTextFieldCommon(
                    controller: EnterAmountController,
                    text: "Enter Amount",
                    labelText: AppLocalizations.of(context)!.enter_amount,
                    tohide: false,
                    textinputtype: TextInputType.number,
                  ),
                ),
                Expanded(
                  child: uiHelper.customTextFieldCommon(
                    controller: AccountNumberController,
                    text: "Enter Account Number",
                    labelText: AppLocalizations.of(context)!.last_digit,
                    tohide: false,
                    textinputtype: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            uiHelper.customButton(
              callback: () async {
                if (EnterAccountNameController.text.isEmpty ||
                    EnterHolderNameController.text.isEmpty ||
                    EnterAmountController.text.isEmpty ||
                    AccountNumberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                double amount =
                    double.tryParse(EnterAmountController.text) ?? 0.0;

                final provider =
                Provider.of<AccountProvider>(context, listen: false);

                if (isEdit) {
                  // ✅ UPDATE
                  await provider.updateAccount(
                    widget.account!['id'],
                    EnterAccountNameController.text,
                    EnterHolderNameController.text,
                    AccountNumberController.text,
                    amount,
                  );
                } else {
                  // ✅ ADD
                  await provider.AddAccount(
                    EnterAccountNameController.text,
                    EnterHolderNameController.text,
                    AccountNumberController.text,
                    amount,
                  );
                }

                Navigator.pop(context);
              },
              buttonname: isEdit ? AppLocalizations.of(context)!.update_account : AppLocalizations.of(context)!.save_account,
            ),
          ],
        ),
      ),
    );
  }
}
