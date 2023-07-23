//require("@nomiclabs/hardhat-waffle");
// require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config({ path: ".env" });


const ALCHEMY_GOERLI_API_KEY_URL = process.env.ALCHEMY_GOERLI_API_KEY_URL;

const ALCHEMY_MUMBAI_API_KEY_URL = process.env.ALCHEMY_MUMBAI_API_KEY_URL;

//contract address key
const ACCOUNT_PRIVATE_KEY = process.env.ACCOUNT_PRIVATE_KEY;

//beneficial address key
const ACCOUNT_PRIVATE_KEY2 = process.env.ACCOUNT_PRIVATE_KEY2;

const INFURA_MAINNET_API_URL = process.env.INFURA_MAINNET_API_KEY_URL;

module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
      forking:{
        url: INFURA_MAINNET_API_URL,
      }
    },
    goerli: {
      url: ALCHEMY_GOERLI_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
    },
    mumbai: {
      url: ALCHEMY_MUMBAI_API_KEY_URL,
      accounts: [ACCOUNT_PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: "API_TOKEN"
  }
};