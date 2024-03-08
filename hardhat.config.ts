import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'

const config: HardhatUserConfig = {
  solidity: '0.8.19',
  networks: {
    optimismSepolia: {
      accounts: [
        'd02eea6052529458cca873975cf6b226a92282758784a2e06d6733aa45ea47b9'
      ],
      chainId: 11155420,
      gasPrice: 15000000,
      url: 'https://sepolia.optimism.io'
    },
    sepolia: {
      chainId: 11155111,
      url: 'https://ethereum-sepolia-rpc.publicnode.com',
      accounts: [
        'd02eea6052529458cca873975cf6b226a92282758784a2e06d6733aa45ea47b9'
      ]
    }
  }
}

export default config
