import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wallet_core/wallet_core.dart';

// Khai báo các hằng số chứa mnemonic, privateKey và địa chỉ
const _mnemonic =
    'fix veteran arrest agree sting wave regular garden robust dog deal tuna';
const _privateKey =
    'd445ee5ff874d09c68523c37a4e0738ed272401ecc1fb804bedb081af0de5ab5';
const _address = '0x1C4677497bC59Dd3E188320D2048DD4947De349F';

String storedKeyMnemonic = """
{"activeAccounts":[{"address":"0x1C4677497bC59Dd3E188320D2048DD4947De349F","coin":60,"derivationPath":"m/44'/60'/0'/0/0","publicKey":"040667a702f3359d54449e6e34e66611b12871f90de4ba166d9789e0e9f327efb8b11766e62cd481c2e5baf855eaa07132a5e7b9e5b619d3591b77ac51eb3aa587"}],"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"5a97f1757ae02692b67dac1b1ed9b072"},"ciphertext":"ed93aa782441c10409d953661658089472dc5d5177b0a0fb789805836a70856347257dccd4c9cccbf9eac118263b9bb85de9abca6dff97f55eea9f597beab71604c52a38a0e6bc","kdf":"scrypt","kdfparams":{"dklen":32,"n":16384,"p":4,"r":8,"salt":""},"mac":"2a394e99116667c8be8a0468861ba394394365c4be36046949a42be3948c0605"},"id":"bd2ebf51-553f-438b-9eec-3a448b172a7d","name":"name","type":"mnemonic","version":3}
""";

String storedKeyPrivateKey = """
{"activeAccounts":[{"address":"0x1C4677497bC59Dd3E188320D2048DD4947De349F","coin":60,"derivationPath":"m/44'/60'/0'/0/0","publicKey":"040667a702f3359d54449e6e34e66611b12871f90de4ba166d9789e0e9f327efb8b11766e62cd481c2e5baf855eaa07132a5e7b9e5b619d3591b77ac51eb3aa587"}],"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"0b86a9dd401b52117cfa02c09950e81b"},"ciphertext":"8b054cc68697f19cb42c199e956483e26db6088bbe3bfc35a9c00654288e6649","kdf":"scrypt","kdfparams":{"dklen":32,"n":16384,"p":4,"r":8,"salt":""},"mac":"cd6b36d8ee8a1c892e8c048641cf0ce227c86694e7751aed4dbe235d88b1ca29"},"id":"05eb526a-3789-4801-adc3-63916b99afc3","name":"name2","type":"private-key","version":3}
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
      'Save Wallet with mnemonic': testSaveWalletWithMnemonic(),
      'Save Wallet with private key': testSaveWalletWithPrivateKey(),
      'Load Stored Key':
          testLoadStoredKeyWithMnemonic(), // Kiểm tra tải mnemonic
      'Load Stored Key with Private Key': testLoadStoredKeyWithPrivateKey(),
      'Wallet Balance': await testWalletBalance(), // Kiểm tra balance
      'Send Transaction': await testSendTransaction(), // Kiểm tra gửi giao dịch
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

            ElevatedButton(
              onPressed: () {
                test1();
                test2();
                test3();
                test4();
                test5();
              },
              child: const Text('Run Test 1'), // Nhãn nút
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
    AWallet wallet =
        WalletCore.walletManagement.importWalletWithPrivateKey(_privateKey);
    print('TestCase #3 address: ${wallet.address}');
    return wallet.address ==
        _address; // So sánh địa chỉ nhập vào với địa chỉ ban đầu
  }

  // Hàm kiểm tra lưu trữ wallet bằng mnemonic
  bool testSaveWalletWithMnemonic() {
    AWallet wallet = WalletCore.walletManagement.importWallet(_mnemonic);
    String? jsonExported =
        WalletCore.storedManagement.saveWallet('name', 'password', wallet);

    print('TestCase #4 jsonExported: $jsonExported');
    return jsonExported != null; // Kiểm tra nếu jsonExported không null
  }

  // Hàm kiểm tra lưu trữ wallet bằng private key
  bool testSaveWalletWithPrivateKey() {
    AWallet wallet =
        WalletCore.walletManagement.importWalletWithPrivateKey(_privateKey);
    String? jsonExported =
        WalletCore.storedManagement.saveWallet('name2', 'password', wallet);

    print('TestCase #5 jsonExported: $jsonExported');
    return jsonExported != null; // Kiểm tra nếu jsonExported không null
  }

  // Hàm kiểm tra tải private key từ dữ liệu JSON
  bool testLoadStoredKeyWithMnemonic() {
    AWallet? wallet = WalletCore.storedManagement
        .fromSavedJson(storedKeyMnemonic, 'password');

    print('TestCase #6 address: ${wallet?.address}');
    return wallet?.address ==
        _address; // So sánh địa chỉ tải lên với địa chỉ ban đầu
  }

  bool testLoadStoredKeyWithPrivateKey() {
    AWallet? wallet = WalletCore.storedManagement
        .fromSavedJson(storedKeyPrivateKey, 'password');
    print('TestCase #7 address: ${wallet?.address}');
    return wallet?.address == _address;
  }

  // Hàm kiểm tra số dư của ví
  Future<bool> testWalletBalance() async {
    try {
      ChainInfo chainInfo = ChainList.auraEuphoria;
      var balance = await chainInfo
          .getWalletBalance('0xfE217e810FfbeFBD8cB4132d3e8aDFCBE0234262');
      print('Balance: $balance');
      print('Balance in Ether: ${balance / BigInt.from(10).pow(18)}');
      if (balance <= BigInt.from(0)) {
        return false; // Kiểm tra nếu số dư nhỏ hơn 0
      }
      return true; // Kiểm tra nếu số dư lớn hơn 0
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> testSendTransaction() async {
    try {
      AWallet wallet =
          WalletCore.walletManagement.importWalletWithPrivateKey("");

      EvmChainClient evmChains = EvmChainClient(ChainList.auraEuphoria);

      final msg = await evmChains.createTransferTransaction(
        wallet: wallet,
        amount: BigInt.parse('0348bca5a16000', radix: 16),
        gasLimit: BigInt.parse('5208', radix: 16),
        recipient: ''
      );

      var txHash = evmChains.sendTransaction(
        rawTransaction: Uint8List.fromList(msg.encoded)
      );

      print('Transaction hash: $txHash');

      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
