

require('@nomiclabs/hardhat-waffle');
require("dotenv").config();

module.exports = {
  solidity: '0.8.0',
  networks: {
    rinkeby: {
      url: process.env.ALCHEMY_DEV_KEY,
      accounts: [process.env.RINKEBY_KEY],
    },
  },
};
