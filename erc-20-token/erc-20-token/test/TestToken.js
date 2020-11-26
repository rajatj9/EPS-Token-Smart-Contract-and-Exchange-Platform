const BN = require("bn.js");
const TestToken = artifacts.require("EpsToken");

contract("EpsToken", (accounts) => {
  const _totalSupply = new BN(1000000000);
  const _name = "EpsToken";
  const _symbol = "INF";

  it(`should put ${_totalSupply} TestToken in the first account`, async () => {
    const decimals = new BN(10).pow(new BN(18));
    const testTokenInstance = await TestToken.deployed();
    const balance = (await testTokenInstance.totalSupply.call()) / decimals;

    assert.equal(
      balance,
      _totalSupply,
      `${_totalSupply} wasn't in the first account`
    );
  });
  it(`should have ${_name} as its name`, async () => {
    const testTokenInstance = await TestToken.deployed();
    const name = await testTokenInstance.name.call();

    assert.equal(name, _name, `Name is not ${_name}`);
  });
  it(`should have ${_symbol} as its symbol`, async () => {
    const testTokenInstance = await TestToken.deployed();
    const symbol = await testTokenInstance.symbol.call();

    assert.equal(symbol, _symbol, `Symbol is not ${_symbol}`);
  });
});
