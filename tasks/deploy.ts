import { task } from 'hardhat/config'

type ContractName = 'MeemVite'

interface Contract {
	args?: (string | number | (() => string | undefined))[]
	address?: string
	libraries?: () => Record<string, string>
	waitForConfirmation?: boolean
}

task('deploy', 'Deploys MeemVite').setAction(
	async (args, { ethers, upgrades, hardhatArguments }) => {
		const [deployer] = await ethers.getSigners()
		console.log('Deploying contracts with the account:', deployer.address)

		console.log('Account balance:', (await deployer.getBalance()).toString())

		// const nonce = await deployer.getTransactionCount();
		const contracts: Record<ContractName, Contract> = {
			MeemVite: {}
		}

		// This is the OpenSea proxy address which will allow trading to work properly
		let proxyRegistryAddress = ''

		switch (hardhatArguments.network) {
			case 'matic':
			case 'polygon':
				proxyRegistryAddress = '0x58807baD0B376efc12F5AD86aAc70E78ed67deaE'
				break

			case 'rinkeby':
				proxyRegistryAddress = '0xf57b2c51ded3a29e6891aba85459d600256cf317'
				break

			case 'mainnet':
				proxyRegistryAddress = '0xa5409ec958c83c3f309868babaca7c86dcb077c1'
				break

			case 'local':
				proxyRegistryAddress = '0x0000000000000000000000000000000000000000'
				break

			default:
				break
		}

		const MeemVite = await ethers.getContractFactory('MeemVite')

		const meemVite = await upgrades.deployProxy(
			MeemVite,
			[proxyRegistryAddress],
			{
				kind: 'uups'
			}
		)

		await meemVite.deployed()

		console.log('MeemVite deployed to:', meemVite.address)

		return contracts
	}
)
