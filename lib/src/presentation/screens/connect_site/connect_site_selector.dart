import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'connect_site_state.dart';

import 'connect_site_cubit.dart';

class ConnectSiteSessionsSelector extends BlocSelector<ConnectSiteCubit,
    ConnectSiteState, List<SessionData>> {
  ConnectSiteSessionsSelector({
    Key? key,
    required Widget Function(List<SessionData>) builder,
  }) : super(
          key: key,
          builder: (_, sessions) => builder(
            sessions,
          ),
          selector: (state) => state.sessions,
        );
}

class ConnectSiteStatusSelector extends BlocSelector<ConnectSiteCubit,
    ConnectSiteState, ConnectSiteStatus> {
  ConnectSiteStatusSelector({
    Key? key,
    required Widget Function(ConnectSiteStatus) builder,
  }) : super(
          key: key,
          builder: (_, status) => builder(
            status,
          ),
          selector: (state) => state.status,
        );
}
