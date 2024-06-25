import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/presentation/widgets/choose_account_form_widget.dart';

class ChangeAccountFormWidget extends ChooseAccountFormWidget {
  const ChangeAccountFormWidget({
    required super.accounts,
    required super.appTheme,
    required super.isSelected,
    super.titleKey = LanguageKey.inAppBrowserScreenChooseAccountDialogTitle,
    super.key,
  });
}
