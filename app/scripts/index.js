// Import the page's CSS. Webpack will know what to do with it.
// Import libraries we need.
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import metaCoinArtifact from '../../build/contracts/MetaCoin.json'
import CarExchangeArtifact from '../../build/contracts/CarExchangeInterface.json'
// Connection URL


// to log info about you 
// MetaCoin is our usable abstraction, which we'll use through the code below.
const MetaCoin = contract(metaCoinArtifact)
const CarEx = contract(CarExchangeArtifact )
// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
let accounts
let account

const App = {

  start: function () {
    const self = this

    // Bootstrap the MetaCoin abstraction for Use.
    CarEx.setProvider(web3.currentProvider)

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        alert('There was an error fetching your accounts.')
        return
      }

      if (accs.length === 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
        return
      }

      accounts = accs
      account=accounts [0]
    })
  },

  setStatus: function (message) {
    const status = document.getElementById('status')
    status.innerHTML = message
  },

    RegisterCar: function () {

        const self = this
var Acco=document.getElementById('carAddId').value;
var carNum=document.getElementById('carNOId').value;

        let meta
        CarEx.deployed().then(function (instance) {
            meta = instance
         return  meta.register(Acco,carNum,{ from: account })})
.then(function (value) {
self.setStatus("car registered")

        }).catch(function (e) {
         self.setStatus(e)


            console.log(e)
                    })

},
    
SellList: function () { 
        const self = this
var Price=document.getElementById('CarPrice').value;
var carNum=document.getElementById('SellCarNum').value;

        let meta
        CarEx.deployed().then(function (instance) {
            meta = instance
            return meta.List(carNum,Price,{ from: account })}).then(function (value) {
         self.setStatus("you added this car to sell list")

        }).catch(function (e) {
         self.setStatus(e)


            console.log(e)
                    })
    },

BuyCar: function () {
        const self = this
var Cost=document.getElementById('CostId').value;
var carNum=document.getElementById('carNumBuyId').value;
var NOwner=document.getElementById('NOwnerAddId').value;

        let meta
        CarEx.deployed().then(function (instance) {
            meta = instance
            return meta.Buy(carNum,Cost,NOwner,{ from: account })}).then(function (value) {
         self.setStatus("the buy process completed")
        }).catch(function (e) {
         self.setStatus(e)


            console.log(e)
                    })
    },

OwnedC: function () {
        const self = this
var AdressSearch=document.getElementById('AddressTXT').value;
var mytable=document.getElementById("tbCars");
var header=mytable.createTHead(0);
var row= header.insertRow(0);     
var cell= row.insertCell(0);
var st="";
cell .innerHTML = "Car Number";

            let meta
        CarEx.deployed().then(function (instance) {
            meta = instance
          return   meta.getarray.call(AdressSearch)
        }).then(function (_cars) {

         var r = _cars;

for (var i = 0; i <r ; i++) { 
CarEx.deployed().then(function (instance) {
            meta = instance
          return   meta.getdata.call(i)
        }).then(function (_carsno,add) {
if(addressSearch==add)
{
st=st+_carno;
}
}).catch(function (e) {
         self.setStatus(e)


            console.log(e)
                    })
}
self.setStatus(s)   
     }).catch(function (e) {
         self.setStatus(e)


            console.log(e)
                    })
      }
}

window.App = App

window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    
    window.web3 = new Web3(web3.currentProvider);
web3.currentProvider.enable();

  } else {
    console.log('No web3? You should consider trying MetaMask!')
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3  = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
Web3.providers.HttpProvider("http://localhost:8545").enable();

  }

  // Now you can start your app & access web3 freely:
  App.start()


})