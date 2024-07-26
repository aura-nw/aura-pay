import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/aura_util.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'package:pyxis_v2/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';
import 'package:pyxis_v2/src/presentation/widgets/combine_list_view.dart';
import 'package:pyxis_v2/src/presentation/widgets/network_image_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/text_input_search_widget.dart';

class _SendSelectTokenWidget extends StatelessWidget {
  final bool isSelected;
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final String avatar;
  final String amount;
  final double value;
  final String symbol;
  final String tokenName;

  const _SendSelectTokenWidget({
    required this.isSelected,
    required this.appTheme,
    required this.localization,
    required this.amount,
    required this.avatar,
    required this.value,
    required this.tokenName,
    required this.symbol,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        color: isSelected ? appTheme.bgBrandPrimary : appTheme.bgPrimary,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: Row(
        children: [
          NetworkImageWidget(
            url: avatar,
            appTheme: appTheme,
            cacheTarget: BoxSize.boxSize07,
            height: BoxSize.boxSize07,
            width: BoxSize.boxSize07,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: AppTypoGraPhy.textMdBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  tokenName,
                  style: AppTypoGraPhy.textXsMedium.copyWith(
                    color: appTheme.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount.toString(),
                style: AppTypoGraPhy.textMdBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
              const SizedBox(
                height: BoxSize.boxSize02,
              ),
              Text(
                '${localization.translate(LanguageKey.commonBalancePrefix)}${value.formatPrice}',
                style: AppTypoGraPhy.textXsMedium.copyWith(
                  color: appTheme.textTertiary,
                ),
              ),
            ],
          ),
          if (isSelected) ...[
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            SvgPicture.asset(
              AssetIconPath.icCommonYetiHand,
            ),
          ],
        ],
      ),
    );
  }
}

final class SendSelectTokensWidget extends AppBottomSheetBase {
  final List<Balance> tokens;
  final List<TokenMarket> tokenMarkets;
  final Balance currentToken;

  const SendSelectTokensWidget({
    required super.appTheme,
    required super.localization,
    required this.tokens,
    required this.tokenMarkets,
    required this.currentToken,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SendSelectTokensWidgetState();
}

final class _SendSelectTokensWidgetState
    extends AppBottomSheetBaseState<SendSelectTokensWidget> {
  TokenMarket? currentTokenMarket;

  List<Balance> displayTokens = List.empty(growable: true);

  @override
  void initState() {
    currentTokenMarket = widget.tokenMarkets.firstWhereOrNull(
      (m) => m.id == widget.currentToken.tokenId,
    );
    displayTokens.addAll(
      widget.tokens,
    );
    super.initState();
  }

  @override
  Widget titleBuilder(BuildContext context) {
    return Text(
      localization.translate(
        LanguageKey.sendScreenSelectTokenTitle,
      ),
      style: AppTypoGraPhy.textLgBold.copyWith(
        color: appTheme.textPrimary,
      ),
    );
  }

  @override
  Widget contentBuilder(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: BoxSize.boxSize14,
        maxHeight: BoxSize.boxSize18,
      ),
      child: CombinedListView(
        onRefresh: () {},
        onLoadMore: () {},
        data: displayTokens,
        builder: (token, _) {
          final tokenMarket = widget.tokenMarkets.firstWhereOrNull(
            (m) => m.id == token.tokenId,
          );

          bool isSelected = false;

          if (currentTokenMarket != null) {
            isSelected = currentTokenMarket!.id == tokenMarket?.id ||
                currentTokenMarket!.name == token.name;
          } else {
            isSelected = token.name == widget.currentToken.name;
          }

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                AppNavigator.pop(token);
              }
            },
            child: _SendSelectTokenWidget(
              isSelected: isSelected,
              appTheme: appTheme,
              localization: localization,
              amount: token.type.formatBalance(
                token.balance,
                customDecimal: token.decimal ?? tokenMarket?.decimal,
              ),
              avatar: tokenMarket?.image ?? AppLocalConstant.auraLogo,
              value: 0,
              tokenName: tokenMarket?.name ?? token.name ?? '',
              symbol: tokenMarket?.symbol ?? token.symbol ?? '',
            ),
          );
        },
        canLoadMore: false,
      ),
    );
  }

  @override
  Widget bottomBuilder(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget subTitleBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.spacing07,
      ),
      child: TextInputSearchWidget(
        appTheme: appTheme,
        hintText: localization.translate(
          LanguageKey.sendScreenSelectTokenHint,
        ),
        onChanged: (name, _) {
          _onFilter(name);
        },
      ),
    );
  }

  void _onFilter(String name) {
    displayTokens.clear();

    if (name.isEmpty) {
      displayTokens.addAll(widget.tokens);
    } else {
      final List<Balance> filterList = widget.tokens
          .where(
            (e) => e.name?.contains(name) ?? false,
          )
          .toList();

      displayTokens.addAll(filterList);
    }

    setState(() {

    });
  }
}
