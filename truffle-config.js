// const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider")
const mnemonic =  "";
const API_KEY = ""
module.exports = {
	// See <http://truffleframework.com/docs/advanced/configuration> to customize your Truffle configuration!
	// contracts_build_directory: path.join(__dirname, "client/src/contracts"),
	networks: {
	  development: {
	    host: "127.0.0.1",
	    port: 8545,
	    // gas: 20000000,
	    network_id: "*",
	    skipDryRun: true
	  },
	  ropsten: {
	    provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/" + API_KEY),
	    network_id: 3,
	    gas: 5000000,
		gasPrice: 5000000000, // 5 Gwei
		skipDryRun: true
	  },
	  kovan: {
	    provider: new HDWalletProvider(mnemonic, "https://kovan.infura.io/v3/" + API_KEY),
	    network_id: 42,
	    gas: 5000000,
		gasPrice: 5000000000, // 5 Gwei
		skipDryRun: true
	  },
	  mainnet: {
	    provider: new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/" + API_KEY),
	    network_id: 1,
	    gas: 5000000,
	  },
	  matic: {
	    provider: new HDWalletProvider(mnemonic, "https://polygon-mainnet.infura.io/v3/" + API_KEY),
	    network_id: 137,
	    gas: 5000000,
	    gasPrice: 35000000000 // 5 Gwei
	  }
	},
	compilers: {
		solc: {
			version: "0.6.12",
		},
	},
	plugins: [
		'truffle-plugin-verify'
	],
	api_keys: {
		etherscan: ''
	}
}
