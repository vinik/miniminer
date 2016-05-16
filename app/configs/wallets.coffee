privateKey = process.env.WORK_WALLET_PRIVATE_KEY || 'L2eYjpuLH183wcLpi7pWThQyr8wjJS4C7CHRhY1z4iTzVKo9agFt';
publicKey = process.env.WORK_WALLET_PUBLIC_KEY || '1Gj3PR6fX7UELMWgBQtGwWuhNYonnciS7Z';

module.exports =
    bitcoin:
        workWallet :
            privateKey: privateKey
            publicKey: publicKey
