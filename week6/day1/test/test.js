const Insurance = artifacts.require("TechInsurance");



contract("TechInsurance", async function(accounts){

    it(
        "should add a product", async function(){
            let instance = await Insurance.deployed()
            await instance.addProduct("1234", "sony",web3.utils.toWei('10', 'ether'), {from: accounts[0]});
    });

    it(
        "is for sale", async function(){
            let instance = await Insurance.deployed()
            await instance.addProduct("1234", "sony",web3.utils.toWei('10', 'ether'), {from: accounts[0]});
            let getProduct = await instance.fatch(1);
            assert(getProduct.offered === true, "Error: the Product wasn't setup for sale");
    });

   


});