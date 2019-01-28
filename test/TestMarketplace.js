/* MEW Marketplace tests: Baltazar 2019 Consensys Academy 
*/
var Marketplace = artifacts.require("./Marketplace.sol");

contract('Marketplace', function(accounts) {

  /*  
   * Test 1) Test that MEW marketplace contract creator is first admin on the marketplace.
   */
  it("should correctly set marketplace admin.", function() {
    return Marketplace.deployed()
      .then(instance => instance.MEWadmins.call(accounts[0]))
      .then(isAdmin => assert.equal(isAdmin, true, "MEW marketplace contract creator not set as admin."));
  });

  /*  
   * Test 2) Test that MEW adopters are able to request addition as a MEW store owner.
   */
  it("should add a MEW store owner request.", function() {
    let marketplaceInstance;
    return Marketplace.deployed().then(instance => {
      marketplaceInstance = instance;
      return marketplaceInstance.MEWaddStoreOwnerRequest.sendTransaction({from: accounts[1]});
    })
    .then(() => marketplaceInstance.MEWstoreOwnerRequests.call(0))
    .then(request => {
      assert.equal(request, accounts[1], "MEW store owner request address not correctly stored.");
    });
  });

  /*  
   * Test 3) Test that ensures that admins are able to process requests for additions as a MEW store owner.
   */
  it("should add a MEW store owner from a request.", function() {
    let marketplaceInstance;

    return Marketplace.deployed()
      .then(instance => {
        marketplaceInstance = instance;
      })
      .then(() => marketplaceInstance.MEWaddStoreOwner.sendTransaction(0, accounts[1], {from: accounts[0]}))
      .then(() => marketplaceInstance.MEWstoreOwners.call(accounts[1]))
      .then(isStoreOwner => {
        assert.equal(isStoreOwner, true, "MEW store owner not added correctly.");
      });
  });

  /*  
   * Test 4) Test that types of MEW adopters are correctly identified
   */
  it("should correctly identify addresses as admins.", function() {
    let marketplaceInstance;

    return Marketplace.deployed()
      .then(instance => {
        marketplaceInstance = instance;
      })
      .then(() => marketplaceInstance.MEWfetchUserType.call({from: accounts[0]}))
      .then(accountType => assert.equal(accountType, 'MEW admin', "Admin address not correctly identified."));
  });

  /*  
   * Test 5) Test that various others types of MEW store owners are correctly identified
   */
  it("should correctly identify addresses as MEW store owner.", function() {
    let marketplaceInstance;

    return Marketplace.deployed()
      .then(instance => {
        marketplaceInstance = instance;
      })
      .then(() => marketplaceInstance.MEWfetchUserType.call({from: accounts[1]}))
      .then(accountType => assert.equal(accountType, 'MEW storeOwner', "Store Owner address not correctly identified."));
  });

  /*  
   * Test 6) Test that the various types of MEW adopters are correctly identified.
   */
  it("should correctly identify an address as a MEW adopter.", function() {
    let marketplaceInstance;

    return Marketplace.deployed()
      .then(instance => {
        marketplaceInstance = instance;
      })
      .then(() => marketplaceInstance.MEWfetchUserType.call({from: accounts[2]}))
      .then(accountType => assert.equal(accountType, 'MEW adopter', "MEW adopter address not correctly identified."));
  });

  /*  
   * Test 7) Test that MEW store owners can successfully create new MEW store contracts, and registered in the marketplace.
   */
  it("should let a MEW store owner generate a MEW new store.", function() {
    let marketplaceInstance;

    return Marketplace.deployed()
      .then(instance => {
        marketplaceInstance = instance;
      })
      .then(() => marketplaceInstance.MEWcreateNewStore.sendTransaction(
        'Test MEW Store', 
        'Test MEW Store Description', 
        {from: accounts[1]}))
      .then(() => marketplaceInstance.MEWfetchStoreAddressesByOwner.call({from: accounts[1]}))
      .then(storeAddresses => assert.equal(storeAddresses.length, 1, "MEW store not successfully created."));
  });

});
