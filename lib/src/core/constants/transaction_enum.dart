// ignore_for_file: constant_identifier_names

sealed class TransactionType {
  static const String IBCTransfer = '/ibc.applications.transfer.v1.MsgTransfer';
  static const String IBCReceived = '/ibc.core.channel.v1.MsgRecvPacket';
  static const String IBCAcknowledgement =
      '/ibc.core.channel.v1.MsgAcknowledgement';
  static const String IBCUpdateClient = '/ibc.core.client.v1.MsgUpdateClient';
  static const String IBCTimeout = '/ibc.core.channel.v1.MsgTimeout';
  static const String IBCChannelOpenInit =
      '/ibc.core.channel.v1.MsgChannelOpenInit';
  static const String IBCConnectionOpenInit =
      '/ibc.core.connection.v1.MsgConnectionOpenInit';
  static const String IBCCreateClient = '/ibc.core.client.v1.MsgCreateClient';
  static const String IBCChannelOpenAck =
      '/ibc.core.channel.v1.MsgChannelOpenAck';
  static const String Send = '/cosmos.bank.v1beta1.MsgSend';
  static const String MultiSend = '/cosmos.bank.v1beta1.MsgMultiSend';
  static const String Delegate = '/cosmos.staking.v1beta1.MsgDelegate';
  static const String Undelegate = '/cosmos.staking.v1beta1.MsgUndelegate';
  static const String Redelegate = '/cosmos.staking.v1beta1.MsgBeginRedelegate';
  static const String GetReward =
      '/cosmos.distribution.v1beta1.MsgWithdrawDelegatorReward';
  static const String SwapWithinBatch =
      '/tendermint.liquidity.v1beta1.MsgSwapWithinBatch';
  static const String DepositWithinBatch =
      '/tendermint.liquidity.v1beta1.MsgDepositWithinBatch';
  static const String EditValidator =
      '/cosmos.staking.v1beta1.MsgEditValidator';
  static const String CreateValidator =
      '/cosmos.staking.v1beta1.MsgCreateValidator';
  static const String Unjail = '/cosmos.slashing.v1beta1.MsgUnjail';
  static const String StoreCode = '/cosmwasm.wasm.v1.MsgStoreCode';
  static const String InstantiateContract =
      '/cosmwasm.wasm.v1.MsgInstantiateContract';
  static const String ExecuteContract = '/cosmwasm.wasm.v1.MsgExecuteContract';
  static const String ModifyWithdrawAddress =
      '/cosmos.distribution.v1beta1.MsgSetWithdrawAddress';
  static const String JoinPool = '/osmosis.gamm.v1beta1.MsgJoinPool';
  static const String LockTokens = '/osmosis.lockup.MsgLockTokens';
  static const String JoinSwapExternAmountIn =
      '/osmosis.gamm.v1beta1.MsgJoinSwapExternAmountIn';
  static const String SwapExactAmountIn =
      '/osmosis.gamm.v1beta1.MsgSwapExactAmountIn';
  static const String BeginUnlocking = '/osmosis.lockup.MsgBeginUnlocking';
  static const String Vote = '/cosmos.gov.v1beta1.MsgVote';
  static const String Vesting =
      '/cosmos.vesting.v1beta1.MsgCreateVestingAccount';
  static const String Deposit = '/cosmos.gov.v1beta1.MsgDeposit';
  static const String SubmitProposalTx =
      '/cosmos.gov.v1beta1.MsgSubmitProposal';
  static const String GetRewardCommission =
      '/cosmos.distribution.v1beta1.MsgWithdrawValidatorCommission';
  static const String PeriodicVestingAccount =
      '/cosmos.vesting.v1beta1.MsgCreatePeriodicVestingAccount';
  static const String BasicAllowance =
      '/cosmos.feegrant.v1beta1.BasicAllowance';
  static const String PeriodicAllowance =
      '/cosmos.feegrant.v1beta1.PeriodicAllowance';
  static const String MsgGrantAllowance =
      '/cosmos.feegrant.v1beta1.MsgGrantAllowance';
  static const String MsgRevokeAllowance =
      '/cosmos.feegrant.v1beta1.MsgRevokeAllowance';
  static const String AllowedMsgAllowance =
      '/cosmos.feegrant.v1beta1.AllowedMsgAllowance';
  static const String AllowedContractAllowance =
      '/cosmos.feegrant.v1beta1.AllowedContractAllowance';
  static const String GrantAuthz = '/cosmos.authz.v1beta1.MsgGrant';
  static const String ExecuteAuthz = '/cosmos.authz.v1beta1.MsgExec';
  static const String RevokeAuthz = '/cosmos.authz.v1beta1.MsgRevoke';
  static const String Fail = 'FAILED';
}
