import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/language_key.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/core/utils/aura_util.dart';
import 'package:aurapay/src/core/utils/dart_core_extension.dart';
import 'package:aurapay/src/navigator.dart';
import 'package:aurapay/src/presentation/widgets/app_bar_widget.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';
import 'package:aurapay/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_provider.dart';
import 'package:aurapay/src/presentation/screens/wallet_manage/widgets/add_wallet_menu_bottom_sheet.dart';

class ManageWalletScreen extends StatefulWidget {
  const ManageWalletScreen({super.key});

  @override
  State<ManageWalletScreen> createState() => _ManageWalletScreenState();
}

class _ManageWalletScreenState extends State<ManageWalletScreen>
    with StateFulBaseScreen {
  final AccountUseCase _accountUseCase = getIt.get<AccountUseCase>();
  final BalanceUseCase _balanceUseCase = getIt.get<BalanceUseCase>();
  final TokenUseCase _tokenUseCase = getIt.get<TokenUseCase>();
  final TokenMarketUseCase _tokenMarketUseCase = getIt.get<TokenMarketUseCase>();

  List<Account> _allAccounts = [];
  Map<int, double> _accountBalances = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  Future<void> _loadWallets() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Load all accounts from database
      final accounts = await _accountUseCase.getAll();
      
      if (accounts.isEmpty) {
        if (mounted) {
          setState(() {
            _allAccounts = [];
            _accountBalances = {};
            _isLoading = false;
          });
        }
        return;
      }

      // Load tokens and token markets for balance calculation
      final tokens = await _tokenUseCase.getAll();
      final tokenMarkets = await _tokenMarketUseCase.getAll();

      final Map<int, double> balances = {};

      // Calculate balance for each account
      for (final account in accounts) {
        try {
          final accountBalance = await _balanceUseCase.getByAccountID(
            accountId: account.id,
          );

          if (accountBalance != null && accountBalance.balances.isNotEmpty) {
            double totalBalance = 0;

            for (final balance in accountBalance.balances) {
              final token = tokens.firstWhereOrNull(
                (e) => e.id == balance.tokenId,
              );

              if (token == null) continue;

              final tokenMarket = tokenMarkets.firstWhereOrNull(
                (e) => e.symbol == token.symbol,
              );

              final amount = double.tryParse(
                    token.type.formatBalance(
                      balance.balance,
                      customDecimal: token.decimal,
                    ),
                  ) ??
                  0;

              double currentPrice =
                  double.tryParse(tokenMarket?.currentPrice ?? '0') ?? 0;

              if (amount != 0 && currentPrice != 0) {
                totalBalance += amount * currentPrice;
              }
            }

            balances[account.id] = totalBalance;
          } else {
            balances[account.id] = 0.0;
          }
        } catch (e) {
          // If error loading balance for an account, set to 0
          balances[account.id] = 0.0;
        }
      }

      if (mounted) {
        setState(() {
          _allAccounts = accounts;
          _accountBalances = balances;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Account> get _mainWallets {
    return _allAccounts
        .where((account) => 
            account.createType == AccountCreateType.normal ||
            account.createType == AccountCreateType.social)
        .toList();
  }

  List<Account> get _importedWallets {
    return _allAccounts
        .where((account) => account.createType == AccountCreateType.import)
        .toList();
  }

  String _formatBalance(int accountId) {
    final balance = _accountBalances[accountId] ?? 0.0;
    return '\$${balance.formatPrice}';
  }

  void _showAddWalletMenu(
    BuildContext context,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    AppBottomSheetProvider.showFullScreenDialog(
      context,
      appTheme: appTheme,
      child: AddWalletMenuBottomSheet(
        appTheme: appTheme,
        localization: localization,
        onCreateNewWallet: () {
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).pop(); // Close manage wallet screen
          AppNavigator.push(RoutePath.createWallet);
        },
        onAddExistingWallet: () {
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).pop(); // Close manage wallet screen
          AppNavigator.push(RoutePath.selectNetwork);
        },
      ),
    );
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_allAccounts.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: appTheme.textTertiary,
                  ),
                  const SizedBox(height: Spacing.spacing04),
                  Text(
                    'No wallets found',
                    style: AppTypoGraPhy.textLgMedium.copyWith(
                      color: appTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddButton(context, appTheme, localization),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadWallets,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(BoxSize.boxSize04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_mainWallets.isNotEmpty) ...[
                    _buildSectionHeader(
                      localization.translate(LanguageKey.manageWalletScreenMainWallets),
                      appTheme,
                    ),
                    const SizedBox(height: Spacing.spacing03),
                    ..._mainWallets.map((account) => _buildWalletItem(
                          key: ValueKey('main_wallet_${account.id}'),
                          account: account,
                          appTheme: appTheme,
                          isMain: true,
                        )),
                    const SizedBox(height: Spacing.spacing05),
                  ],
                  if (_importedWallets.isNotEmpty) ...[
                    _buildSectionHeader(
                      localization.translate(LanguageKey.manageWalletScreenImportedWallets),
                      appTheme,
                    ),
                    const SizedBox(height: Spacing.spacing03),
                    ..._importedWallets.map((account) => _buildWalletItem(
                          key: ValueKey('imported_wallet_${account.id}'),
                          account: account,
                          appTheme: appTheme,
                          isMain: false,
                        )),
                  ],
                ],
              ),
            ),
          ),
        ),
        _buildAddButton(context, appTheme, localization),
      ],
    );
  }

  Widget _buildSectionHeader(String title, AppTheme appTheme) {
    return Text(
      title,
      style: AppTypoGraPhy.textLgBold.copyWith(
        color: appTheme.textPrimary,
      ),
    );
  }

  Widget _buildWalletItem({
    Key? key,
    required Account account,
    required AppTheme appTheme,
    required bool isMain,
  }) {
    final address = account.aEvmInfo.displayAddress.isNotEmpty
        ? account.aEvmInfo.displayAddress
        : account.aCosmosInfo.displayAddress;

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: Spacing.spacing03),
      padding: const EdgeInsets.all(Spacing.spacing04),
      decoration: BoxDecoration(
        color: appTheme.bgSecondary,
        borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius04),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isMain
                  ? const Color(0xFFE3F2FD)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: isMain
                  ? const Color(0xFF1976D2)
                  : const Color(0xFF388E3C),
              size: 24,
            ),
          ),
          const SizedBox(width: Spacing.spacing04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: AppTypoGraPhy.textMdMedium.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.spacing01),
                Text(
                  address.addressView,
                  style: AppTypoGraPhy.textSmRegular.copyWith(
                    color: appTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.spacing01),
                Text(
                  _formatBalance(account.id),
                  style: AppTypoGraPhy.textMdMedium.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: appTheme.fgPrimary,
            ),
            onPressed: () {
              // TODO: Show wallet options menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return Container(
      padding: const EdgeInsets.all(BoxSize.boxSize04),
      decoration: BoxDecoration(
        color: appTheme.bgPrimary,
        border: Border(
          top: BorderSide(
            color: appTheme.borderSecondary,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showAddWalletMenu(context, appTheme, localization);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.bgBrandPrimary,
              padding: const EdgeInsets.symmetric(vertical: Spacing.spacing04),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  BorderRadiusSize.borderRadius05,
                ),
              ),
            ),
            child: Text(
              localization.translate(LanguageKey.manageWalletScreenAddOrImport),
              style: AppTypoGraPhy.textMdMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      appBar: AppBarDefault(
        appTheme: appTheme,
        localization: localization,
        titleKey: LanguageKey.manageWalletScreenAppBarTitle,
      ),
      body: child,
    );
  }
}

