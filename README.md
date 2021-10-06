# MeemVite token

MeemVite NFT token

## Contract address

### Rinkeby

MeemVite: [0xB117C7cc3cBdA283A98f2BF1eD55242d5d438bc2](https://rinkeby.etherscan.io/address/0xB117C7cc3cBdA283A98f2BF1eD55242d5d438bc2)

MeemViteURI: [0xfD4E238B06FE747294515c4ef366bbB9d92E1dC7](https://rinkeby.etherscan.io/address/0xfD4E238B06FE747294515c4ef366bbB9d92E1dC7)

Opensea: [https://testnets.opensea.io/collection/meem-project](https://testnets.opensea.io/collection/meem-project)

## Metadata

* Metadata standards for opensea: https://docs.opensea.io/docs/metadata-standards

* Contract (opensea collection) standards for opensea: https://docs.opensea.io/docs/contract-level-metadata

## Development

By default all commands will use the local network. For other networks use the ```--network <network_name>``` flag. See the hardhat.config.ts file for network names.

### Install dependencies

```yarn```

### Watch and compile files automatically

```yarn watch```

### Run local blockchain

This will start up a local node using hardhat

```yarn node```

**NEVER SEND ETH TO THESE ADDRESSES EXCEPT ON YOUR LOCAL NETWORK**

## Smart Contract Interaction

> **Change the network**
>
> For (deploy, upgrade, console) commands, you can change the network with `--network rinkeby`
>
> The local network is used by default.

### Deploy contract

**You should only do this the first time. After that you should use upgrade to keep the same address**

```yarn deploy```

### Upgrade the contract

```yarn upgrade --contract-address <address>```

## Console Interaction

This will open a hardhat console where you can interact directly with the smart contract

```yarn console```

### Get a meem instance for use in hardhat console

```
const meemVite = await (await ethers.getContractFactory('MeemVite')).attach('<Contract_address>')
```

### Mint a meem

The last parameter is the royalty percentage w/ 2 decimals. 1000 == 10%

```
await meem.mint('<To address>', '<Royalty address>', 1000)
```

### Get meem metadata uri

```
await meem.tokenURI(<Meem id>)

await meem.tokenURI(0)
```

### Grant a role

Available Roles:

* `DEFAULT_ADMIN_ROLE`
* `PAUSER_ROLE`
* `MINTER_ROLE`
* `UPGRADER_ROLE`

```
await meem.grantRole((await meem.MINTER_ROLE()), '<address>')
```

## Faucets

### Rinkeby

* https://faucet.rinkeby.io/
* https://app.mycrypto.com/faucet
* http://rinkeby-faucet.com/
* https://faucets.blockxlabs.com/ethereum

Offline / Not working consistently
* https://rinkeby.faucet.epirus.io/#


### Ropsten

5 ETH every 24 hours: https://faucet.dimensions.network/

1 ETH but spotty availability: https://faucet.metamask.io/