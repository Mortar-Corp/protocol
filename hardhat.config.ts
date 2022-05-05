require('dotenv').config()
require('@nomiclabs/hardhat-ethers')
require('@openzeppelin/hardhat-upgrades')

const { API_URL, PRIVATE_KEY } = process.env

module.exports = {
  solidity: '0.8.4',
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      chainId: 1337,
    },
    local: {
      url: 'http://127.0.0.1:8545',
      // accounts: [`0x${PRIVATE_KEY}`],
    },
    mrtrTestnet: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
      // default Metamask gas price
      gasPrice: 2,
    },
    // mumbai: {
    //   url: API_URL,
    //   accounts: [`0x${PRIVATE_KEY}`],
    //   gas: 2100000,
    //   gasPrice: 8000000000,
    //   timeout: 60000,
    // },
    // mainnet: {
    //    url: `https://polygon-mainnet.infura.io/v3/${infuraId}`,
    //    accounts: [`0x${PRIVATE_KEY}`]
    // }
  },
}
