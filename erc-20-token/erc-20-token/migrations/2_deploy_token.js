const EpsToken = artifacts.require("EpsToken");

module.exports = function (deployer) {
  deployer.deploy(EpsToken);
};
