const Insurance = artifacts.require("TechInsurance");

module.exports = function (deployer) {
  deployer.deploy(Insurance);
};
