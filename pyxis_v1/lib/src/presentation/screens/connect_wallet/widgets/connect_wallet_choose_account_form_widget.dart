import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/presentation/widgets/choose_account_form_widget.dart';

class ConnectWalletChooseAccountFormWidget extends ChooseAccountFormWidget {
  const ConnectWalletChooseAccountFormWidget({
    required super.accounts,
    required super.appTheme,
    required super.isSelected,
    super.titleKey = LanguageKey.connectWalletScreenChooseAccount,
    super.key,
  });
}
