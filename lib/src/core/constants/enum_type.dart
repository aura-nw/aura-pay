enum OnBoardingChoiceOption{
  createAccount,
  importAccount,
  recoverAccount,
}

enum ChoiceModalType{
  single,
  multi,
}

enum ChoiceModalSize{
  small,
  medium,
  high,
}

enum PyxisWalletType{
  smartAccount,
  normalWallet,
}

enum ImportWalletType{
  privateKey,
  passPhrase,
}

enum OnboardingType{
  create,
  import,
  recover,
}

enum RecoverOptionType{
  google,
  backupAddress,
}

// Cosmos msg type
enum MsgType{
  send,
  recover,
  executeContract,
  other,
}