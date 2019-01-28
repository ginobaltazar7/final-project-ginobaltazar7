/* MEW Store tests: Baltazar 2019 Consensys Academy 
*/
var Store = artifacts.require("./Store.sol");


contract('Store', function(accounts) {
  let contract;

  before(() => Store.new(accounts[0], 'Test MEW Store Name', 'Test MEW Store Description')
    .then(instance => contract = instance));

  /*  
   * Test 1) Test that MEW store contract creator is new owner of the MEW store.
   */
  it("should set the MEW store owner correctly.", function() {
    return contract.MEWowner.call()
      .then(owner => assert.equal(owner, accounts[0], "MEW store contract creator not set as owner."));
  });

  /*  
   * Test 2) Test that the MEW store owner can create a new product in the store, and product instantiates correctly.
   */
  it("should allow MEW store owner to add a new product.", function() {
    return contract.MEWaddNewProduct.sendTransaction('Test MEW Product 1', 'Test MEW Product 1 Description', 1)
      .then(() => contract.MEWproductsBySku.call(1))
      .then(product => {
        assert.equal(product[0].toNumber(), 1, "MEW Product's SKU not correctly set.");
        assert.equal(product[1].toNumber(), 0, "MEW Product's inventory not set (initially) to zero.");
        assert.equal(product[2].toNumber(), 1, "MEW Product's price not set correctly.");
        assert.equal(product[3], "Test MEW Product 1", "MEW product name not set correctly.");
        assert.equal(product[4], "Test MEW Product 1 Description", "MEW product description not set correctly.");
      });
  });

  /*  
   * Test 3) Test that MEW store owner can update inventory for an existing product.
   */
  it("should allow MEW store owner to add inventory for an existing product.", function() {
    return contract.MEWupdateInventoryCount.sendTransaction(1, 5)
      .then(() => contract.MEWproductsBySku.call(1))
      .then(product => {
        assert.equal(product[1].toNumber(), 5, "MEW product inventory failed to update correctly.");
      });
  });

  /*  
   * Test 4) Test that the MEW adopter can purchase a MEW product, while adjusting inventory balance
   */
  it("should allow MEW adopters purchase a product from the MEW store, and product balance updates with  correct amount.", function() {
    return contract.MEWpurchaseProduct.sendTransaction(1, 5, {value: 5})
      .then(() => contract.MEWproductsBySku.call(1))
      .then(product => {
        assert.equal(product[1].toNumber(), 0, "MEW product inventory balance failed to update correctly after a sale.");
      });
  });



});
