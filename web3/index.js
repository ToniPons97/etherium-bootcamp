window.addEventListener('load', async () => {
  // Select DOM elements
  const enableMetaMaskButton = document.querySelector('.enableMetamask');
  const statusText = document.querySelector('.statusText');
  const listenToEventsButton = document.querySelector(
    '.startStopEventListener'
  );
  const contractAddr = document.querySelector('#address');
  const eventResult = document.querySelector('.eventResult');
  const pastEventsBtn = document.querySelector('.getPastEventsBtn');

  // Event listeners
  enableMetaMaskButton.addEventListener('click', enableDapp);
  listenToEventsButton.addEventListener('click', toggleEventListener);
  pastEventsBtn.addEventListener('click', getPastEvents);

  // Global variables
  let accounts = [];
  let web3;
  let contractInstance;
  let eventListenerActive = false;

  // Contract ABI
  const abi = [
    {
      inputs: [],
      stateMutability: 'nonpayable',
      type: 'constructor',
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: 'address',
          name: '_from',
          type: 'address',
        },
        {
          indexed: true,
          internalType: 'address',
          name: '_to',
          type: 'address',
        },
        {
          indexed: false,
          internalType: 'uint256',
          name: '_amount',
          type: 'uint256',
        },
      ],
      name: 'TokensSent',
      type: 'event',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: '_to',
          type: 'address',
        },
        {
          internalType: 'uint256',
          name: '_amount',
          type: 'uint256',
        },
      ],
      name: 'sendTokens',
      outputs: [
        {
          internalType: 'bool',
          name: '',
          type: 'bool',
        },
      ],
      stateMutability: 'nonpayable',
      type: 'function',
    },
    {
      inputs: [
        {
          internalType: 'address',
          name: '',
          type: 'address',
        },
      ],
      name: 'tokenBalance',
      outputs: [
        {
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
      ],
      stateMutability: 'view',
      type: 'function',
    },
  ];

  async function enableDapp() {
    // Check if MetaMask (or any Ethereum provider) is available

    if (typeof window.ethereum !== 'undefined') {
      try {
        // Request account access
        accounts = await window.ethereum.request({
          method: 'eth_requestAccounts',
        });

        // Initialize Web3 with MetaMask's provider
        web3 = new Web3(window.ethereum);
        console.log(`Is MetaMask provider? ${window.ethereum.isMetaMask}`);

        // Display the connected account
        statusText.textContent = `Account: ${accounts[0]}`;

        // Enable input fields and buttons
        listenToEventsButton.removeAttribute('disabled');
        contractAddr.removeAttribute('disabled');
      } catch (error) {
        if (error.code === 4001) {
          // User rejected the request
          statusText.textContent =
            'Error: Permission to access MetaMask was denied.';
        } else {
          console.error(error);
          statusText.textContent = `Error: ${error.message}`;
        }
      }
    } else {
      // MetaMask was not detected
      statusText.textContent = 'Error: Need to install MetaMask';
    }
  }

  // Function to toggle event listening
  function toggleEventListener() {
    if (!eventListenerActive) {
      listenToEvents();
    } else {
      stopListeningToEvents();
    }
  }

  // Function to start listening to events
  function listenToEvents() {
    const address = contractAddr.value.trim();

    // Validate the contract address
    if (!web3.utils.isAddress(address)) {
      eventResult.innerHTML = 'Invalid contract address.';
      return;
    }

    // Initialize the contract instance
    contractInstance = new web3.eth.Contract(abi, address);

    // Subscribe to the TokensSent event
    contractInstance.events
      .TokensSent()
      .on('data', (event) => {
        console.log(event);

        const { _from, _to, _amount } = event.returnValues;
        const eventInfo = `TokensSent - From: ${_from}, To: ${_to}, Amount: ${_amount}`;
        eventResult.innerHTML = `${eventInfo}<br />${eventResult.innerHTML}`;
      })
      .on('error', (error) => {
        console.error('Error on event', error);
        eventResult.innerHTML = `Error: ${error.message}`;
      });

    // Update UI state
    eventListenerActive = true;
    listenToEventsButton.textContent = 'Stop Listening';
  }

  // Function to stop listening to events
  function stopListeningToEvents() {
    if (
      contractInstance &&
      contractInstance.events &&
      contractInstance.events.TokensSent
    ) {
      contractInstance.events.TokensSent().unsubscribe((error, success) => {
        if (success) {
          console.log('Successfully unsubscribed!');
        }
      });
      eventListenerActive = false;
      listenToEventsButton.textContent = 'Listen to Events';
      eventResult.innerHTML = 'Event listener stopped.';
    }
  }

  async function getPastEvents() {
    const tokensSentEvents = await contractInstance.getPastEvents(
      'TokensSent',
      {
        fromBlock: 0,
        toBlock: 'latest',
      }
    );

    console.log(tokensSentEvents);
  }

  // Listen for account and network changes
  if (window.ethereum) {
    window.ethereum.on('accountsChanged', (newAccounts) => {
      if (newAccounts.length > 0) {
        accounts = newAccounts;
        statusText.textContent = `Account: ${accounts[0]}`;
      } else {
        statusText.textContent = 'Please connect to MetaMask.';
        listenToEventsButton.setAttribute('disabled', 'true');
        contractAddr.setAttribute('disabled', 'true');
      }
    });

    window.ethereum.on('chainChanged', (chainId) => {
      // Handle the new chain. You may want to reload the page.
      window.location.reload();
    });
  }
});
