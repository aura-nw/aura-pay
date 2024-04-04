import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/address_book/widgets/update_address_book_widget.dart';
import 'widgets/add_address_book_widget.dart';
import 'widgets/address_book_detail_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'widgets/address_book_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';
import 'address_book_event.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

import 'address_book_bloc.dart';
import 'address_book_state.dart';
import 'address_book_selector.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({super.key});

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen>
    with CustomFlutterToast {
  final AddressBookBloc _bloc = getIt.get<AddressBookBloc>();

  @override
  void initState() {
    _bloc.add(
      const AddressBookOnFetchEvent(),
    );
    super.initState();
  }

  void _onAdded() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    if (context.mounted) {
      showSuccessToast(
        AppLocalizationManager.of(context).translate(
          LanguageKey.addressBookScreenAddContactAdded,
        ),
      );
    }
  }

  void _onEdited() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    if (context.mounted) {
      showSuccessToast(
        AppLocalizationManager.of(context).translate(
          LanguageKey.addressBookScreenEditContactEdited,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<AddressBookBloc, AddressBookState>(
        listener: (context, state) async {
          switch (state.status) {
            case AddressBookStatus.loading:
              break;
            case AddressBookStatus.loaded:
              break;
            case AddressBookStatus.error:
              break;
            case AddressBookStatus.added:
              _onAdded();
              break;
            case AddressBookStatus.edited:
              _onEdited();
              break;
            case AddressBookStatus.removed:
              break;
          }
        },
        child: AppThemeBuilder(
          builder: (appTheme) {
            return Scaffold(
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey.addressBookScreenAppBarTitle,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing05,
                    vertical: Spacing.spacing07,
                  ),
                  child: AddressBookStatusSelector(
                    builder: (status) {
                      switch (status) {
                        case AddressBookStatus.loading:
                          return Center(
                            child: AppLoadingWidget(
                              appTheme: appTheme,
                            ),
                          );
                        case AddressBookStatus.loaded:
                        case AddressBookStatus.error:
                        case AddressBookStatus.edited:
                        case AddressBookStatus.removed:
                        case AddressBookStatus.added:
                          return Column(
                            children: [
                              Expanded(
                                child: AddressBookContactsSelector(
                                  builder: (contacts) {
                                    if (contacts.isEmpty) {
                                      return Center(
                                        child: AppLocalizationProvider(
                                          builder: (localization, _) {
                                            return Text(
                                              localization.translate(
                                                LanguageKey
                                                    .addressBookScreenEmptyContact,
                                              ),
                                              style: AppTypoGraPhy.bodyMedium02
                                                  .copyWith(
                                                color: appTheme.contentColor500,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                    return CombinedListView(
                                      onRefresh: () {
                                        //
                                      },
                                      onLoadMore: () {
                                        //
                                      },
                                      data: contacts,
                                      builder: (contact, _) {
                                        return AddressBookWidget(
                                          name: contact.name,
                                          address: contact.address,
                                          appTheme: appTheme,
                                          key: ValueKey(
                                            contact,
                                          ),
                                          onTap: () {
                                            _showDetailForm(
                                              appTheme,
                                              contact,
                                            );
                                          },
                                        );
                                      },
                                      canLoadMore: false,
                                    );
                                  },
                                ),
                              ),
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return PrimaryAppButton(
                                    leading: SvgPicture.asset(
                                      AssetIconPath.commonAdd,
                                      color: appTheme.contentColorWhite,
                                    ),
                                    text: localization.translate(
                                      LanguageKey.addressBookScreenAddContact,
                                    ),
                                    onPress: _showAddForm,
                                  );
                                },
                              ),
                            ],
                          );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddForm() {
    AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: AddAddressBookWidget(
        onConfirm: (address, name) {
          _bloc.add(
            AddressBookOnAddEvent(
              name: name,
              address: address,
            ),
          );
        },
      ),
    );
  }

  void _showDetailForm(
    AppTheme appTheme,
    AddressBook addressBook,
  ) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: AddressBookDetailFormWidget(
        appTheme: appTheme,
        name: addressBook.name,
        address: addressBook.address,
        onEdit: () {
          AppNavigator.pop();
          _showUpdateForm(addressBook);
        },
        onRemove: () {
          AppNavigator.pop();
          _bloc.add(
            AddressBookOnDeleteEvent(
              id: addressBook.id,
            ),
          );
        },
      ),
    );
  }

  void _showUpdateForm(
    AddressBook addressBook,
  ) {
    AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: UpdateAddressBookWidget(
        onConfirm: (address, name) {
          _bloc.add(
            AddressBookOnUpdateEvent(
              id: addressBook.id,
              name: name,
              address: address,
            ),
          );
        },
        name: addressBook.name,
        address: addressBook.address,
      ),
    );
  }
}
