import { ethers } from 'hardhat'

async function main () {
  const easContract = '0x4200000000000000000000000000000000000021'

  const superChainDummyContract = await ethers.deployContract(
    'SuperChainDummyAccounts',
    [easContract]
  )
  const superChainDummyResponse =
    await superChainDummyContract.waitForDeployment()

  const dummyErc20 = await ethers.deployContract('DummyERC20')
  const dummyErc20Response = await dummyErc20.waitForDeployment()
  const dummyErc20Address = await dummyErc20Response.getAddress()

  const resolver = await ethers.deployContract('TokensResolver', [
    easContract,
    dummyErc20Address,
    ethers.parseEther('10')
  ])
  const resolverResponse = await resolver.waitForDeployment()
  const resolverAddress = await resolverResponse.getAddress()

  console.log(`Resolver contract: ${resolverAddress} \n
    ERC20 contract: ${dummyErc20Address} \n
    SuperChain contract: ${await superChainDummyResponse.getAddress()}
  `)
}

main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
