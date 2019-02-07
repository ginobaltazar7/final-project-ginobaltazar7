# Decentralized Online MEW Marketplace for Endangered Wildlife

Supplemental README and Front End Screenshots
Consensys Academy Final Project
Gino Baltazar - baltazar.gino@gmail.com

## Supplemental Install README

This is a short update to clarify the project's Node and other dependencies. 

Running "npm install" may fail to install and progress if Node is not the latest version 11.9+, "build essentials" are not detected by the truffle install and if node-gyp build tool is not installed correctly (it requires a degraded Python 2.7).

Follow the steps outlined either in a VirtualBox VM environment or another virtual environment like Docker.

1. sudo usermod -a -G sudo ubuntu
2. sudo apt update
3. sudo apt install git
4. sudo apt install curl
5. sudo apt-get update
6. curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
7. >> Close and reopen terminal or command prompt <<
8. command -v nvm
9. nvm install node
10. node -v (should say v.11.9.0)
11. mkdir ~/.npm-global
12. npm config set prefix ‘~/.npm-global’
13. export PATH=~/.npm-global/bin:$PATH
14. nvm use --delete-prefix v11.9.0 --silent
15. source ~/.profile
16. npm install -g typescript
17. sudo apt-get install build-essential
18. sudo apt-get install python2.7
19. sudo ln -s /usr/bin/python2.7 /usr/bin/python (because node-gyp rebuild uses python2.x)
20. npm install -g node-gyp
21. npm install -g truffle
22. npm install -g ganache-cli
23. git clone https://github.com/dev-bootcamp-2019/final-project-ginobaltazar7.git
24. cd final-project-ginobaltazar7
25. npm install iconv -g
26. npm install
27. ganache-cli
28. truffle compile
29. truffle migrate
30. npm run start

Then navigate to localhost:3000 on a Firefox or Chrome browser with Metamask installed and ganache running. 

## MEW Marketplace Front End screenshots

Enclosed is a link to a number of screenshots in the following folder describing a workflow, which briefly:

1. On a separate browser tab, set the Metamask to "Private Network" and Account 1. Confirm that the last 3 digits of Account 1 in Metamask matches the first private key in Ganache. 

2. In another browser tab, launch localhost:3000 and you'll see an opening screen waiting for a MEW store request.

3. On the Metamask, go to Account 2 by copying/pasting a private key from ganache, refresh the localhost:3000 browser tab to see a request with Ether paid to get permission to create shop. Going back to Account 1 will see an approval, which subsequently can be used to create a shop and update product inventory.

Screenshots link --> https://github.com/dev-bootcamp-2019/final-project-ginobaltazar7/tree/master/frontendscreenshots



