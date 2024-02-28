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

// NFT layout type
enum NFTLayoutType{
  list,
  grid,
}

// Support media type
enum MediaType{
  image,
  video,
  audio,
}

// In app browser
enum BrowserOpenType{
  // When users click or input url. It will update current tab
  normal,
  // When users click other tab in tab management screen
  chooseOther,
  // maybe add more options late
}