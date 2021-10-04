import { task, types } from 'hardhat/config'

type ContractName = 'Meem'

interface Contract {
	args?: (string | number | (() => string | undefined))[]
	address?: string
	libraries?: () => Record<string, string>
	waitForConfirmation?: boolean
}

task('upgradeContract', 'Deploys Meem Gate Token')
	.addParam(
		'contractaddress',
		'The originally deployed contract address',
		undefined,
		types.string,
		false
	)
	.setAction(async (args, { ethers, upgrades }) => {
		const [deployer] = await ethers.getSigners()
		console.log('Deploying contracts with the account:', deployer.address)

		console.log('Account balance:', (await deployer.getBalance()).toString())

		const contracts: Record<ContractName, Contract> = {
			Meem: {}
		}

		const MeemVite = await ethers.getContractFactory('MeemVite')
		const meemVite = await upgrades.upgradeProxy(args.contractaddress, MeemVite)

		await meemVite.deployed()

		console.log('MeemVite deployed to:', meemVite.address)

		return contracts
	})
