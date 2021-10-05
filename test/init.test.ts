import { assert } from 'chai'
import { Signer } from 'ethers'
import { ethers } from 'hardhat'
import { MeemVite } from '../typechain/MeemVite'

async function getContract(): Promise<MeemVite> {
	const MV = await ethers.getContractFactory('MeemVite')
	const meemVite = await MV.deploy()
	await meemVite.deployed()

	return meemVite as MeemVite
}

describe('MeemVite', function Test() {
	// let accounts: Signer[]

	// beforeEach(async () => {
	// 	accounts = await ethers.getSigners()
	// })

	it('should do something right', async () => {
		const meemVite = await getContract()
		const [owner, addr1] = await ethers.getSigners()
		console.log({ owner, addr1, ethers })
		// Do something with the accounts
		// console.log({ accounts, name: meemVite.functions })
		// assert.isArray(accounts)
		// assert.isAbove(accounts.length, 1)
	})
})
