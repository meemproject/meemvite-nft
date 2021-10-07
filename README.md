# MeemVite token

A MeemVite token connects you directly with the MeemDAO team on Discord as a full "Meember".

Join us in building the future of digital content where creators set the rules: [https://discord.gg/5NP8PYN8](https://discord.gg/5NP8PYN8)

## Contract addresses

### Polygon (MATIC) Mainnet



### Rinkeby Testnet

MeemVite: [0xB117C7cc3cBdA283A98f2BF1eD55242d5d438bc2](https://rinkeby.etherscan.io/address/0xB117C7cc3cBdA283A98f2BF1eD55242d5d438bc2)

MeemViteURI: [0x98FcF9C8bB265C74818F5eC4fC067e564304361a](https://rinkeby.etherscan.io/address/0x98FcF9C8bB265C74818F5eC4fC067e564304361a)

Opensea: [https://testnets.opensea.io/collection/meem-project](https://testnets.opensea.io/collection/meem-project)

## Metadata

All metadata is 100% on-chain!

* Metadata standards for opensea: https://docs.opensea.io/docs/metadata-standards

* Contract (opensea collection) standards for opensea: https://docs.opensea.io/docs/contract-level-metadata

## Development

By default all commands will use the local network. For other networks use the ```--network <network_name>``` flag. See the hardhat.config.ts file for network names.

### Set up your .env

Copy the `.env.example` file to .env

### Install dependencies

```yarn```

### Watch and compile files automatically

```yarn watch```

### Run tests

```yarn test```

### Run local blockchain

This will start up a local node using hardhat

```yarn network```

**NEVER SEND ETH TO THESE ADDRESSES EXCEPT ON YOUR LOCAL NETWORK**

## Smart Contract Interaction

> **Change the network**
>
> For (deploy, upgrade, console, etc.) commands, you can change the network with `--network <network name>`
>
> The local network is used by default.

### Deploy contract

**You should only do this the first time. After that you should use upgrade to keep the same address**

#### Deploy MeemVite contract

```yarn deploy```

#### Deploy MeemVite URI contract

```yarn deployURI```

### Upgrade the contract

```yarn upgradeContract --contract-address <address>```

## Console Interaction

This will open a hardhat console where you can interact directly with the smart contract

```yarn console```

### Get a meem instance for use in hardhat console

```
const meemVite = await (await ethers.getContractFactory('MeemVite')).attach('<Contract_address>')
```

### Set the token URI contract

To properly return the `tokenURI`, the contract of the MeemViteURI address must be set

```
await meemVite.setTokenURIContractAddress(<MeemViteURI address>)
```

### Mint a MeemVite

```
await meem.mint('<To address>')
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