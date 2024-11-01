(async () => {
    let accounts = await web3.eth.getAccounts();
    console.log(accounts, accounts.length);

    let balance = await web3.eth.getBalance('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4');
    console.log(balance + ' wei');
    console.log(web3.utils.fromWei(balance, 'ether'));
})();