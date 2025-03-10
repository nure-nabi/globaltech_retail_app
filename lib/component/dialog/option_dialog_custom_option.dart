enum OptionDialogGroup {
  daily,
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
  daily,
  month,
  leaveReport,
  event,
}

class OptionDialogCustomOption {
  final OptionDialogGroup optionDialogGroup;
  final OptionDialogSubGroup? optionDialogSubGroup;

  OptionDialogCustomOption({
    required this.optionDialogGroup,
    this.optionDialogSubGroup,
  });
}
