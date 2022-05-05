## helpful commands

```
npx hardhat test
```

## deploy contracts locally

```
npx hardhat compile
```

```
npx hardhat node
```

```
npx hardhat run scripts/deploy-upgradable.ts --network local
```

## deploy contracts to mrtr tesnet:

npx hardhat compile
npx hardhat run scripts/deploy-upgradable.ts --network mrtrTestnet
npx hardhat run scripts/deploy-upgrade.ts --network mrtrTestnet

## deploy contracts to mainnet

TODO
alchemy RPC url
get some real matic token

```
npx hardhat compile
```

```
npx hardhat run scripts/deploy.ts --network mainnet
```
