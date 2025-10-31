import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';
import 'history_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import 'models/transaction_history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with StateFulBaseScreen {
  late HistoryBloc _bloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = HistoryBloc();
    _bloc.add(const HistoryOnInitEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      bloc: _bloc,
      builder: (context, state) {
        return Column(
          children: [
            // Search bar
            _buildSearchBar(appTheme, localization),
            const SizedBox(height: Spacing.spacing05),

            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localization.translate('history_page_all_transactions'),
                  style: AppTypoGraPhy.textLgSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.spacing04),

            // Transaction list
            Expanded(
              child: _buildTransactionList(state, appTheme, localization),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(
      AppTheme appTheme, AppLocalizationManager localization) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: appTheme.bgSecondary,
          borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
        ),
        child: TextField(
          controller: _searchController,
          style: AppTypoGraPhy.textMdRegular.copyWith(
            color: appTheme.textPrimary,
          ),
          textAlignVertical: TextAlignVertical.center,
          onChanged: (value) {
            _bloc.add(HistoryOnSearchEvent(value));
          },
          decoration: InputDecoration(
            hintText: localization.translate('history_page_search_hint'),
            hintStyle: AppTypoGraPhy.textMdRegular.copyWith(
              color: appTheme.textPlaceholder,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(Spacing.spacing03),
              child: SvgPicture.asset(
                'assets/icon/ic_common_search.svg',
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  appTheme.fgQuaternary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing04,
              vertical: Spacing.spacing03,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(
    HistoryState state,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    if (state.status == HistoryStatus.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: appTheme.fgBrandPrimary,
        ),
      );
    }

    if (state.status == HistoryStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? localization.translate('history_page_error_occurred'),
          style: AppTypoGraPhy.textMdRegular.copyWith(
            color: appTheme.textErrorPrimary,
          ),
        ),
      );
    }

    if (state.filteredTransactions.isEmpty) {
      return Center(
        child: Text(
          localization.translate('history_page_no_transactions'),
          style: AppTypoGraPhy.textMdRegular.copyWith(
            color: appTheme.textTertiary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _bloc.add(const HistoryOnRefreshEvent());
        // Wait for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 600));
      },
      color: appTheme.fgBrandPrimary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing0),
        itemCount: state.filteredTransactions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: appTheme.borderSecondary,
        ),
        itemBuilder: (context, index) {
          final transaction = state.filteredTransactions[index];
          return _buildTransactionItem(transaction, appTheme, localization);
        },
      ),
    );
  }

  Widget _buildTransactionItem(
    TransactionHistoryModel transaction,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to transaction detail
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Spacing.spacing04),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.getTypeDisplayName(localization.translate),
                    style: AppTypoGraPhy.textMdSemiBold.copyWith(
                      color: appTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Spacing.spacing01),
                  Text(
                    _formatDateTime(transaction.timestamp),
                    style: AppTypoGraPhy.textSmRegular.copyWith(
                      color: appTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.displayAmount,
                  style: AppTypoGraPhy.textMdSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.spacing01),
                Text(
                  transaction.getStatusDisplayName(localization.translate),
                  style: AppTypoGraPhy.textSmRegular.copyWith(
                    color: _getStatusColor(transaction.status, appTheme),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat timeFormat = DateFormat('HH:mm');
    final DateFormat dateFormat = DateFormat('dd MMM, yyyy');
    return '${timeFormat.format(dateTime)} ${dateFormat.format(dateTime)}';
  }

  Color _getStatusColor(TransactionStatus status, AppTheme appTheme) {
    switch (status) {
      case TransactionStatus.pending:
        return appTheme.textWarningPrimary;
      case TransactionStatus.success:
        return appTheme.textSuccessPrimary;
      case TransactionStatus.failed:
        return appTheme.textErrorPrimary;
    }
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.all(Spacing.spacing05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localization.translate('history_page_title'),
                  style: AppTypoGraPhy.displayXsSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
