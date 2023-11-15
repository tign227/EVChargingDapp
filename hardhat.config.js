require("@nomicfoundation/hardhat-toolbox");

// Go to https://infura.io, sign up, create a new API key
// in its dashboard, and replace "KEY" with it
const SEPOLIA_API_URL = "https://eth-sepolia.g.alchemy.com/v2/T8GltN0ck7mm64eVk_4lq7TLpq9Z8gOE";

const SEPOLIA_PRIVATE_KEY = "82d143e7fcd212b6e49ee9017d97e56e4a604eb0c67c3a3c46b8159f3e0299a2";


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: SEPOLIA_API_URL,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  }
};
