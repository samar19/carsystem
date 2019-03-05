pragma solidity ^0.5.0;
contract CarExchangeInterface{
    struct   car{
        uint256 _CVinNumber;
        address _Cowner;
    }
 car[] public cars;
  mapping(uint256=>car) carreg;
   struct BuyDone{
       address New_Owner;
       address Old_Owner;
       uint256 Value;
   }
    BuyDone[] public buyBook;
    mapping(uint256=>uint256) carSellList;
    
   
    uint[] public vNum;
    uint Totalcount=0;
    event Registered(address indexed_owner,uint256 indexed_VinNumber);
     event BOught(address indexedOld_owner,uint256 indexed_VinNumber,address indexedNew_owner,uint256 Indexd_Value);
     
     
    function register(address _owner,uint256 _VinNumber) public returns (bool added)
    {
            Totalcount+=1;
    car memory car1;
    car1._CVinNumber=_VinNumber;
    car1._Cowner=_owner;
    cars.push(car1);
   emit  Registered(_owner,_VinNumber);

     return true;
    }
    
    function List(uint256 _VinNumber,uint256 Value) public  returns (bool added)
    {
        
        carSellList[_VinNumber]=Value;
        return true;
    }
    function Buy(uint256 _VinNumber,uint256 Value,address _owner)public returns (bool added)
    {
           
            address Last_Owner ;
            Last_Owner=carreg[_VinNumber]._Cowner;
          
             BuyDone memory BuyDone1;
            BuyDone1. New_Owner=_owner;
            BuyDone1.Old_Owner=Last_Owner;
            BuyDone1.Value=Value;
            buyBook.push(BuyDone1);
           delete carSellList[_VinNumber];
           cars[_VinNumber]._Cowner=_owner;
           for(uint256 i=0;i<cars.length;i++)
           {
               if (cars[i]._CVinNumber==_VinNumber&& cars[i]._Cowner==Last_Owner)
               {
                   cars[i]._Cowner=_owner;
               }
           }
           emit  BOught(Last_Owner,_VinNumber,_owner,Value);
        return true;
    }
function  getArray() public returns (uint256 i ) {
      return cars.length;
  }

  
   function getdata(uint256 i) public returns (uint256 m,address j ) {
      return (cars[i]._CVinNumber,cars[i]._Cowner);
  }
   

   
   
}