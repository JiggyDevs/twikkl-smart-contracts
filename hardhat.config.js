require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config({ path: ".env" });
require("@matterlabs/hardhat-zksync-solc");
require("@matterlabs/hardhat-zksync-deploy");


const ALCHEMY_GOERLI_API_KEY_URL = process.env.ALCHEMY_GOERLI_API_KEY_URL;

const ALCHEMY_MUMBAI_API_KEY_URL = process.env.ALCHEMY_MUMBAI_API_KEY_URL;

const ALCHEMY_SEPOLIA_API_KEY = process.env.ALCHEMY_SEPOLIA_API_KEY;

//contract address key
const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;

//beneficial address key
// const ACCOUNT_PRIVATE_KEY2 = process.env.ACCOUNT_PRIVATE_KEY2;

const INFURA_MAINNET_API_URL = process.env.INFURA_MAINNET_API_KEY_URL;

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

module.exports = {
  defaultNetwork: "zkSyncMainnet",
  zksolc: {
    version: "1.2.0",
    compilerSource: "binary", 
    settings: {},
  },
  networks: {
    hardhat: {
      forking:{
        url: INFURA_MAINNET_API_URL,
      },
      allowUnlimitedContractSize: true,
    },
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/key"
    },
    zkSyncTestnet: {
      url: "https://sepolia.era.zksync.dev", 
      ethNetwork: "sepolia", 
      zksync: true
    },
    zkSyncMainnet: {
      url: "https://sepolia.era.zksync.dev", 
      ethNetwork: "https://mainnet.infura.io/v3/key", 
      zksync: true
    },
    goerli: {
      url: ALCHEMY_GOERLI_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
    mumbai: {
      url: ALCHEMY_MUMBAI_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
      gasLimit: 500000000,
    },
  },
  etherscan: {
    apiKey: [ETHERSCAN_API_KEY]
  },
  solidity: {
    version: "0.8.17", 
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};