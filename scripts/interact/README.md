
1. **前提条件：**
   - 基本了解以太坊和智能合约。
   - 在计算机上安装了Node.js和npm。

2. **项目设置：**
   - 创建新的项目目录：`mkdir smart-contract-guide`，然后切换到该目录。
   - 初始化Node.js项目并安装Hardhat：`npm init -y` 和 `npm install --save-dev hardhat`。

3. **编写智能合约：**
   - 在项目目录下创建名为 `SimpleContract.sol` 的文件，编写智能合约代码。

4. **部署脚本：**
   - 在 `scripts` 目录下创建名为 `deploy.js` 的文件，编写部署脚本。

5. **配置Hardhat：**
   - 创建名为 `hardhat.config.js` 的文件，配置Solidity版本和网络信息。

6. **部署合约：**
   - 打开终端，导航到项目目录，运行命令：`npx hardhat run scripts/deploy.js --network <network-name>`。

7. **创建交互脚本：**
   - 在 `scripts` 目录下创建名为 `interact.js` 的文件，编写与智能合约交互的脚本。

8. **运行交互脚本：**
   - 打开终端，导航到项目目录，运行命令：`npx hardhat run scripts/interact.js --network <network-name>`。

[代码示例](https://medium.com/@santiagotrujilloz/quick-guide-deploying-interacting-with-a-smart-contract-using-hardhat-f8a4a56a06f7)
