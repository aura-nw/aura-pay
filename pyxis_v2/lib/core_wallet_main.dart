import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wallet_core/wallet_core.dart';

// Khai báo các hằng số chứa mnemonic, privateKey và địa chỉ
const _mnemonic =
    'fix veteran arrest agree sting wave regular garden robust dog deal tuna';
const _privateKey =
    'd445ee5ff874d09c68523c37a4e0738ed272401ecc1fb804bedb081af0de5ab5';
const _address = '0x1C4677497bC59Dd3E188320D2048DD4947De349F';

const jsonTest = """
{"activeAccounts":[{"address":"0x1C4677497bC59Dd3E188320D2048DD4947De349F","coin":60,"derivationPath":"m/44'/60'/0'/0/0","publicKey":"040667a702f3359d54449e6e34e66611b12871f90de4ba166d9789e0e9f327efb8b11766e62cd481c2e5baf855eaa07132a5e7b9e5b619d3591b77ac51eb3aa587"}],"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"6468fb1d63a6d09156ec1a3a57cdb2fe"},"ciphertext":"6a2de3fdc9b4f3d1d9265dfdd9c0130f33c6ff80adaaf63265000f52eca8f7eb","kdf":"scrypt","kdfparams":{"dklen":32,"n":16384,"p":4,"r":8,"salt":""},"mac":"811998542a34618b4e80c273d91730419486fb54417339638a5afbe13bb45230"},"id":"beb55ff0-25a5-4d4e-953c-b6ef40f6fe86","name":"name","type":"private-key","version":3}
""";

// Hàm main để khởi tạo WalletCore và chạy ứng dụng Flutter
void main() {
  WalletCore.init(); // Khởi tạo WalletCore
  runApp(const MyApp()); // Chạy ứng dụng
}

// StatelessWidget MyApp định nghĩa ứng dụng
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mnemonic App', // Tiêu đề ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue, // Thiết lập màu chủ đạo
      ),
      home: const MyHomePage(), // Đặt màn hình chính của ứng dụng
    );
  }
}

// StatefulWidget MyHomePage định nghĩa màn hình chính của ứng dụng
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State của MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  // Biến Future để lưu trữ kết quả kiểm tra
  Future<Map<String, bool>>? _testResults;

  // Hàm kiểm tra các chức năng của WalletCore
  Future<Map<String, bool>> startCheck() async {
    return {
      'Random Mnemonic':
          testCreateRandomWallet(), // Kiểm tra tạo mnemonic ngẫu nhiên
      'Import Mnemonic': testImportWallet(), // Kiểm tra nhập mnemonic
      'Import Private Key':
          testImportWalletWithPrivateKey(), // Kiểm tra nhập private key
      'Stored Key': testStoredKey(), // Kiểm tra lưu trữ private key
      'Load Stored Key': testLoadStoredKey(), // Kiểm tra tải private key
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mnemonic App'), // Tiêu đề trên AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Kiểm tra nếu _testResults không null
            if (_testResults != null)
              FutureBuilder<Map<String, bool>>(
                future: _testResults, // Tương lai chứa kết quả kiểm tra
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Hiển thị khi đang chờ kết quả
                  } else if (snapshot.hasError) {
                    return const Text(
                        'An error occurred'); // Hiển thị khi có lỗi xảy ra
                  } else if (snapshot.hasData) {
                    final results = snapshot.data!;
                    return Column(
                      children: <Widget>[
                        // Hiển thị kết quả của từng kiểm tra
                        for (var entry in results.entries)
                          Text(
                              '${entry.key}: ${entry.value ? 'Passed' : 'Failed'}'),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return const Text(
                        'No results available'); // Hiển thị khi không có kết quả
                  }
                },
              ),
            // Nút "Run Test" để bắt đầu kiểm tra
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _testResults =
                      startCheck(); // Cập nhật _testResults khi nhấn nút
                });
              },
              child: const Text('Run Test'), // Nhãn nút
            ),
          ],
        ),
      ),
    );
  }

  // Hàm kiểm tra tạo mnemonic ngẫu nhiên
  bool testCreateRandomWallet() {
    String mnemonic = WalletCore.walletManagement.randomMnemonic();
    print('TestCase #1 mnemonic: $mnemonic');
    return mnemonic.isNotEmpty; // Kiểm tra nếu mnemonic không rỗng
  }

  // Hàm kiểm tra nhập mnemonic
  bool testImportWallet() {
    AWallet wallet = WalletCore.walletManagement.importWallet(_mnemonic);
    print('TestCase #2 privateKey: ${wallet.privateKey}');
    if (wallet.wallet == null) return false; // Kiểm tra nếu wallet không null
    return wallet.wallet!.mnemonic() ==
        _mnemonic; // So sánh mnemonic nhập vào với mnemonic ban đầu
  }

  // Hàm kiểm tra nhập private key
  bool testImportWalletWithPrivateKey() {
    AWallet aWallet =
        WalletCore.walletManagement.importWalletWithPrivateKey(_privateKey);
    print('TestCase #3 address: ${aWallet.address}');
    return aWallet.address ==
        _address; // So sánh địa chỉ nhập vào với địa chỉ ban đầu
  }

  bool testStoredKey() {
    AWallet wallet = WalletCore.walletManagement.importWallet(_mnemonic);
    var privateKey = WalletCore.walletManagement.getPrivateKey(wallet.wallet!);

    String? jsonExported = WalletCore.storedManagement
        .storePrivateKey('name', 'password', privateKey);

    print('TestCase #4 jsonExported: $jsonExported');
    return jsonExported != null;
  }

  bool testLoadStoredKey() {
    StoredKey? storedKey = WalletCore.storedManagement.fromJson(jsonTest);
    PrivateKey? loadedPk =
        storedKey?.privateKey(60, Uint8List.fromList('password'.codeUnits));
    print('TestCase #5 loadedPk: $loadedPk');
    return loadedPk != null;
  }
}
