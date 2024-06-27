import { ethers } from 'ethers';

class CreateWalletFromMnemonicUseCase {
    execute(mnemonic: string): ethers.HDNodeWallet {
        const wallet = ethers.Wallet.fromPhrase(mnemonic); // Tạo instance từ mnemonic
        return wallet;
    }
}
