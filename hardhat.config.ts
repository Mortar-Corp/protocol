require('dotenv').config();
require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY } = process.env;

module.exports = {
   solidity: "0.8.4",
   defaultNetwork: "hardhat",
   networks: {
      hardhat: {
         chainId: 1337
      },
      // mumbai: {
      //    url: API_URL,
      //    accounts: [`0x${PRIVATE_KEY}`]
      // },
      // matic: {
      //    url: `https://polygon-mainnet.infura.io/v3/${infuraId}`,
      //    accounts: [`0x${PRIVATE_KEY}`]
      // }
   },
}