import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura Smart Account Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Aura Smart Account Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ScreenLoaderMixin{
  String? _error;
  String? _smartAccountAddress;
  late AuraWalletCore _auraWalletCore;

  late AuraSmartAccount _auraSmartAccount;

  AuraWallet? _auraWallet;

  @override
  void initState() {
    _auraWalletCore = AuraWalletCore.create(
      environment: AuraEnvironment.testNet,
    );

    _auraSmartAccount = AuraSmartAccount.create(
      AuraSmartAccountEnvironment.test,
    );
    super.initState();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _createWallet,
                child: const Text('Create Wallet'),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Wallet Address = ${_auraWallet?.bech32Address}'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _generateSmartAccount,
                child: const Text('Generate smart account'),
              ),
              Text('Smart Account Address = $_smartAccountAddress'),
              const SizedBox(
                height: 20,
              ),
              Text(
                '$_error',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createWallet() async {
    showLoading();
    _auraWallet = await _auraWalletCore.createRandomHDWallet();

    setState(() {});

    hideLoading();
  }

  void _generateSmartAccount() async {
    if (_auraWallet == null) {
      _error = 'Let\'s try to create wallet before create smart account';
      setState(() {});
      return;
    }

    _error = null;

    setState(() {});

    try {
      showLoading();
      final QueryGenerateAccountResponse smartAccountResponse =
          await _auraSmartAccount.generateSmartAccount(
        pubKey: _auraWallet!.publicKey,
        salt: Uint8List.fromList(
          utf8.encode('test'),
        ),
      );

      _smartAccountAddress = smartAccountResponse.address;

      dev.log('Smart account address = $_smartAccountAddress');
    } catch (e, s) {
      _error = e.toString();

      dev.log(e.toString(), stackTrace: s);
    }finally{
      setState(() {});
      hideLoading();
    }
  }
}

mixin ScreenLoaderMixin<T extends StatefulWidget> on State<T> {
  final loadingController = StreamController<bool>();

  Widget _buildLoader() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: 72,
      height: 72,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.blueAccent,
      ),
    );
  }

  @override
  void dispose() {
    loadingController.close();

    super.dispose();
  }

  void showLoading() {
    loadingController.add(true);
  }

  void hideLoading() {
    loadingController.add(false);
  }

  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        builder(context),
        StreamBuilder(
          stream: loadingController.stream,
          builder: (_, snapshot) => snapshot.data == true
              ? Positioned.fill(
                  child: _buildLoader(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
