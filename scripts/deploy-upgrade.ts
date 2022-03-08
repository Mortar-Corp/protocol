async function mainUpgrade() {
  // ** use the addresses from OG deployment - this will keep address constant
  const Market = await ethers.getContractFactory('Market')
  await upgrades.upgradeProxy('CONTRACT_ADDRESS', Market)
  console.log('Market upgraded')

  const NFT = await ethers.getContractFactory('NFT')
  await upgrades.upgradeProxy('CONTRACT_ADDRESS', NFT)
  console.log('NFT upgraded')
}

mainUpgrade()
