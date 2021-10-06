import { task } from 'hardhat/config'

type ContractName = 'MeemViteURI'

interface Contract {
	args?: (string | number | (() => string | undefined))[]
	address?: string
	libraries?: () => Record<string, string>
	waitForConfirmation?: boolean
}

task('deployURI', 'Deploys MeemViteURI').setAction(async (args, { ethers }) => {
	const [deployer] = await ethers.getSigners()
	console.log('Deploying contracts with the account:', deployer.address)

	console.log('Account balance:', (await deployer.getBalance()).toString())

	// const nonce = await deployer.getTransactionCount();
	const contracts: Record<ContractName, Contract> = {
		MeemViteURI: {}
	}

	const MeemViteURI = await ethers.getContractFactory('MeemViteURI')

	const meemViteURI = await MeemViteURI.deploy()

	await meemViteURI.deployed()

	console.log('MeemViteURI deployed to:', meemViteURI.address)

	return contracts
})
