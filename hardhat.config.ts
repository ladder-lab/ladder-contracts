import '@nomiclabs/hardhat-etherscan';
import 'dotenv/config';
import "hardhat-deploy";
import 'hardhat-contract-sizer';

import { HardhatUserConfig } from "hardhat/config";

const accounts = [
      process.env.MNEMONIC ||
      "0000000000000000000000000000000000000000000000000000000000000000",
];

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  networks: {
    ethereum: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 1,
    },
    hardhat: {
      forking: {
        enabled: process.env.FORKING === "true",
        url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      },
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 3,
      gasMultiplier: 15,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 4,
      gasMultiplier: 15,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts,
      chainId: 5,
      gasMultiplier: 15,
    },
    bsc: {
      url: `https://bsc-dataseed.binance.org/`,
      accounts,
    },
    'bsc-testnet': {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545/`,
      accounts,
    }
  },
  solidity: {
    version: '0.8.9',
    settings: {
      evmVersion: "istanbul",
      optimizer: {
        enabled: true,
        runs: 999999,
      },
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
  }
};

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
export default config;
