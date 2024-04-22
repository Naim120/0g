sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential liblz4-tool jq make lz4 gcc unzip -y
ver="1.22.2"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
cd $HOME
git clone https://github.com/0glabs/0g-evmos.git
cd 0g-evmos
git checkout v1.0.0-testnet
make build
make install
mkdir -p $HOME/.evmosd/cosmovisor/genesis/bin
mv build/evmosd $HOME/.evmosd/cosmovisor/genesis/bin/
sudo ln -s $HOME/.evmosd/cosmovisor/genesis $HOME/.evmosd/cosmovisor/current -f
sudo ln -s $HOME/.evmosd/cosmovisor/current/bin/evmosd /usr/local/bin/evmosd -f
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@latest
echo 'export MONIKER="pounik"' >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_9000-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="pounik"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile
cd $HOME
evmosd init pounik --chain-id $CHAIN_ID
evmosd config chain-id $CHAIN_ID
evmosd config node tcp://localhost:$RPC_PORT
evmosd config keyring-backend os
wget https://github.com/0glabs/0g-evmos/releases/download/v1.0.0-testnet/genesis.json -O $HOME/.evmosd/config/genesis.json
PEERS="d813235cc2326983e0ea071ffa8acba341df0adb@89.117.56.219:16456,ac1d78038dfa515ec5e44db02831ceb2d1d1d57e@75.119.136.242:26656,da448d3b9fc80a5a4be747dd3d82f9be3812c544@144.126.213.37:16456,e47e39992ba47d7544797ec16eedcd24503a2629@144.91.84.170:26656,5a4d38ac71bf0546333c28ab2be75f069d72508f@84.247.177.86:26656,bf7bdcaf6cc807e53d3a63e64018ea3f57530bd5@213.199.40.126:26656,8ff0124d5f1881b708f459cc464f894b5bcc99be@38.242.212.146:26656,13b748e30700d662dd7516064d08f31a3a7c8e18@62.169.16.169:26656,f4231a379eb5b306210ee8dcde1cf9c1c5eeb965@37.60.228.142:26656,4091fc5a27a91c717b8ce84a3e76f81b96474df1@207.180.252.190:26656,ea224a77f8aa0805561da4047b0a8b2d89ecce2a@213.199.61.159:26656,6b644af890863f830d3e6b37a3e82d7b8847f342@173.212.221.121:16456,84ee5874d03a659dd18b886ea82c1c17b973db50@65.108.209.212:26656,1b06fd4dd3fcd7e530b60a2b6a7f228130906322@141.94.99.181:33656,64e84008878bb053f33b7b76c8684bb12ba53ec8@109.123.246.140:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.evmosd/config/config.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.evmosd/config/app.toml
