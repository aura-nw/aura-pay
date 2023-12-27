import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'nft_event.dart';

import 'nft_state.dart';

final class NFTBloc extends Bloc<NFTEvent, NFTState> {
  final NFTUseCase _nftUseCase;
  final AuraAccountUseCase _accountUseCase;

  NFTBloc(this._nftUseCase, this._accountUseCase)
      : super(
          const NFTState(),
        ) {
    on(_init);
    on(_onRefresh);
    on(_onLoadMore);
    on(_onChangeViewType);
  }

  final _config = getIt.get<PyxisMobileConfig>();

  Future<NFTsInformation> _getNFTsInformation({
    String? owner,
  }) async {
    return _nftUseCase.getNFTsByAddress(
      //owner: owner ?? state.owner,
      owner: 'aura1crh5z8cy0znnj8u48jlttr5h4as8n336jj0gxr',
      environment: _config.environment.environmentString,
      offset: state.offset,
      limit: state.limit,
    );
  }

  void _init(
    NFTEventOnInit event,
    Emitter<NFTState> emit,
  ) async {
    emit(state.copyWith(
      status: NFTStatus.loading,
    ));

    try {
      final account = await _accountUseCase.getFirstAccount();

      final NFTsInformation nftInformation = await _getNFTsInformation();

      emit(
        state.copyWith(
          owner: account?.address ?? '',
          status: NFTStatus.loaded,
          nFTs: nftInformation.cw721Tokens,
          totalNFT: nftInformation.count,
          canLoadMore: nftInformation.cw721Tokens.length >= state.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: NFTStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onLoadMore(
    NFTEventOnLoadMore event,
    Emitter<NFTState> emit,
  ) async {
    if (state.status != NFTStatus.loaded) return;

    emit(
      state.copyWith(
        status: NFTStatus.loadMore,
        offset: state.offset + 20,
      ),
    );

    try {
      final NFTsInformation nftInformation = await _getNFTsInformation();

      emit(
        state.copyWith(
          status: NFTStatus.loaded,
          nFTs: [
            ...state.nFTs,
            ...nftInformation.cw721Tokens,
          ],
          totalNFT: nftInformation.count,
          canLoadMore: nftInformation.cw721Tokens.length >= state.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: NFTStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onRefresh(
    NFTEventOnRefresh event,
    Emitter<NFTState> emit,
  ) async {
    if (state.status != NFTStatus.loaded) return;

    emit(
      state.copyWith(
        status: NFTStatus.refresh,
        nFTs: [],
        offset: 0,
      ),
    );
    try {
      final NFTsInformation nftInformation = await _getNFTsInformation();

      emit(
        state.copyWith(
          status: NFTStatus.loaded,
          nFTs: nftInformation.cw721Tokens,
          totalNFT: nftInformation.count,
          canLoadMore: nftInformation.cw721Tokens.length >= state.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: NFTStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onChangeViewType(
    NFTEventOnSwitchViewType event,
    Emitter<NFTState> emit,
  ) {
    emit(
      state.copyWith(
        viewType: event.type,
        status: NFTStatus.onChangeViewType,
      ),
    );
  }

  static NFTBloc of(BuildContext context) => BlocProvider.of<NFTBloc>(context);
}
