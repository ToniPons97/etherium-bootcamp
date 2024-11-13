const Spacebear = artifacts.require('Spacebear');

module.exports = async function (deployer, network, accounts) {
  // Log the accounts provided by Truffle
  console.log('Accounts:', accounts);

  // Use the first account as the parameter for the contract deployment
  const ownerAddress = accounts[0];

  // Deploy the Spacebear contract with the required constructor argument
  await deployer.deploy(Spacebear, ownerAddress);
};
