/*
    Consensys Final proj on Solidity version 0.5
    Store contract to trade, ie buy and sell, digital representations of Endangered Wildlife
    MEW - Marketplace of Endangered Wildlife, inspired by my love of cats
    To create communities of interest, indirectly funding their conservation
    Baltazar 2019
*/

pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title A simulator Store to trade digital representations of Endangered Wildlife (MEW)
/// @author GBaltazar
/// @notice Very basic simulation; using SafeMath for uint256; product as MEWs
/// @dev Gas costs warning: functions may not execute if gas requirements are too high
contract MEWStore {
  using SafeMath for uint256;

  string public MEWname;
  string public MEWdescription;
  address payable MEWowner;
  mapping (uint256 => MEWProduct) public MEWproductsBySku;
  uint256 public MEWnewestProductSku;
  bool public MEWstopped = false;

  struct MEWProduct {
    uint sku;
    uint inventoryCount;
    uint price;
    string name;
    string description;
  }

  event MEWNewProductAdded(string name, string description, uint256 indexed sku, uint256 price);
  event MEWInventoryCountUpdated(uint256 indexed sku, uint256 newInventoryCount);
  event MEWPurchaseMade(uint256 indexed sku, uint256 quantity);
  event MEWContractStateToggled(bool isStopped);

  modifier MEWisOwner() {
    require(msg.sender == MEWowner, "Allowed action only by MEW store owner.");
    _;
  }

  modifier MEWstringLengthOkay(string memory str) {
    require(bytes(str).length <= 32);
    _;
  }

  modifier MEWskuExists(uint256 sku) {
    require(MEWnewestProductSku.sub(sku) >= 0, "MEW sku does not exist in this store.");
    _;
  }

  modifier MEWenoughInventory(uint256 sku, uint256 quantity) {
    require(MEWproductsBySku[sku].inventoryCount.sub(quantity) >= 0, "Insufficient MEW inventory.");
    _;
  }

  modifier MEWenoughEthSent(uint256 sku, uint256 quantity) {
      require(msg.value >= MEWproductsBySku[sku].price.mul(quantity), "Insufficient Ether.");
      _;

      if (msg.value > MEWproductsBySku[sku].price.mul(quantity)) {
        msg.sender.transfer(msg.value.sub(MEWproductsBySku[sku].price.mul(quantity)));
      }
  }

  modifier MEWstopInEmergency {
    if (!MEWstopped) {
      _;
    }
  }

  modifier MEWonlyInEmergency {
    if (MEWstopped) {
      _;
    }
  }

  /// @dev set sender as person who instantiated the MEW store contract
 constructor(address payable sender, string memory storeName, string memory storeDescription) 
    public
    MEWstringLengthOkay(storeName)
    MEWstringLengthOkay(storeDescription) {
    MEWname = storeName;
    MEWdescription = storeDescription;
    MEWowner = sender;
    MEWnewestProductSku = 0;
  }

  /// @dev MEW Owner can change contract state in case of emergency.
  function MEWtoggleContractActive() 
    public
    MEWisOwner {
      MEWstopped = !MEWstopped;
      emit MEWContractStateToggled(MEWstopped);
  }

  /// @dev MEW Owner can withdraw any funds the store has earned by selling products.
  function MEWwithdraw() public payable MEWisOwner {
    MEWowner.transfer(address(this).balance);
  }

  /// @dev Owner can add MEW products to store to sell.
  /// @param newProductName is name of the new MEW product.
  /// @param newProductDescription The description of the new MEW product.
  /// @param newProductPrice The price of the new MEW product.
  function MEWaddNewProduct(string memory newProductName, string memory newProductDescription, uint256 newProductPrice) 
    public
    MEWisOwner
    MEWstringLengthOkay(newProductName)
    MEWstringLengthOkay(newProductDescription) {
    MEWProduct memory newProduct = MEWProduct({
      sku: MEWnewestProductSku.add(1), 
      inventoryCount: 0, 
      price: newProductPrice,
      name: newProductName, 
      description: newProductDescription
    });

    MEWproductsBySku[MEWnewestProductSku.add(1)] = newProduct;
    MEWnewestProductSku = MEWnewestProductSku.add(1);
    emit MEWNewProductAdded(newProduct.name, newProduct.description, newProduct.sku, newProduct.price);
  }

  /// @dev Owner can update MEW inventory for a given MEW product.
  /// @param sku The MEW product's sku.
  /// @param newInventoryCount Updated MEW product inventory count.
  function MEWupdateInventoryCount(uint256 sku, uint256 newInventoryCount) 
    public
    MEWskuExists(sku) 
    MEWisOwner {

    MEWproductsBySku[sku].inventoryCount = newInventoryCount;
    emit MEWInventoryCountUpdated(sku, newInventoryCount);
  }

  /// @dev Purchase a MEW product from the store.
  /// @param sku The MEW product's SKU.
  /// @param quantity Units of MEW product inventory being purchased.
  function MEWpurchaseProduct(uint256 sku, uint256 quantity) 
    public 
    payable
    MEWskuExists(sku)
    MEWenoughInventory(sku, quantity)
    MEWenoughEthSent(sku, quantity)
    MEWstopInEmergency {

    MEWproductsBySku[sku].inventoryCount = MEWproductsBySku[sku].inventoryCount.sub(quantity);
    emit MEWPurchaseMade(sku, quantity);
  }
  /// @dev Default payable function.
  function () external payable {}
}
