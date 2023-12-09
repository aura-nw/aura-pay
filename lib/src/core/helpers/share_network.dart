import 'package:share_plus/share_plus.dart';
sealed class ShareNetWork{
  static Future<bool> shareWalletAddress(String address)async{
    final shareResult = await Share.shareWithResult(address);

    return shareResult.status == ShareResultStatus.success;
  }
}