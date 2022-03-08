const { ethers, upgrades } = require('hardhat')

async function main() {
  const Market = await ethers.getContractFactory('Market')
  const market = await upgrades.deployProxy(Market)
  await market.deployed()
  console.log('market contract deployed to: ', market.address)

  const NFT = await ethers.getContractFactory('NFT')
  const nft = await upgrades.deployProxy(NFT, [market.address])
  await nft.deployed()
  console.log('NFT contract deployed to: ', nft.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
