enum OptionDialogGroup {
  purchase,
  sales,
  stock,
  cashFlow,
  cashBook,
  bankFlow,
  bankBook,
  allLedger,
  customerLedger,
  vendorLedger,
  otherLedger,
  pdc,
  trialBalance,
  balanceSheet,
  profitLoss,
  restaurant,
  branchWise,
}

enum OptionDialogSubGroup {
  challan,
  order,
  invoice,
  returns,
}

class OptionDialogCustomOption {
  final OptionDialogGroup optionDialogGroup;
  final OptionDialogSubGroup? optionDialogSubGroup;

  OptionDialogCustomOption({
    required this.optionDialogGroup,
    this.optionDialogSubGroup,
  });
}
