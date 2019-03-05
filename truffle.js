// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
     development: {
            host: "localhost",
            port: 8545,
            network_id: "*" // Match any network id
        },
rinkeby: {
            host: "localhost",
            port: 8545,
            network_id: "4", // rinkeby ID
           from:"0x4cF5c2E3dEC0A7e2DD34155a904DDfedD5BA2088",
gas:4600000,
        }

  }
}
