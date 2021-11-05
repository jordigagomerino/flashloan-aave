## Installation and Setup
0. Install Truffle globally, if not already installed.
    ```
    npm install -g truffle@latest
    ```
1. Add your mnemonic and Infura API_KEY.

2. Add Etherscan API-KEY if you want to verify your contract.

4. Install dependencies:
    ```
    npm install
    ```
5. Compile de contracts
    ```
    truffle compile
    ```
5. Deploy to matic
    ```
    truffle migrate --network matic
    ```
5. Deploy to matic
    ```
    truffle run verify Flashloan --network matic
    ```