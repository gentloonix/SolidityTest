const Proxy = artifacts.require("Proxy")
const fs = require('fs')

module.exports = function (deployer) {
    deployer.deploy(Proxy);

    console.log(JSON.stringify(JSON.parse(fs.readFileSync('./build/contracts/Proxy.json', 'utf8')).abi));
}