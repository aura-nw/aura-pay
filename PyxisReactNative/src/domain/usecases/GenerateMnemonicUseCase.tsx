import { ethers } from 'ethers';

class GenerateMnemonicUseCase {
    execute(): string {
        const mnemonic = ethers.Wallet.createRandom().mnemonic.phrase;
        return mnemonic;
    }
}

function generateMnemonicUseCase() {
    const mnemonic = new GenerateMnemonicUseCase().execute();
    console.log(mnemonic);
    return mnemonic;
}