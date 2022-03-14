FROM rust:1.54.0

# Solana Core / Cli Version
ARG SOLANA_VERSION=1.6.22
# Latest Release: https://github.com/solana-labs/solana/releases/latest

# Name of Solana Cluster "Network" use
ARG SOLANA_CLUSTER=devnet
# Devnet: devnet
# Testnet: testnet
# Mainnet Beta: mainnet-beta

# Url for Solana Cluster "Network"
ARG SOLANA_CLUSTER_URL=https://api.devnet.solana.com
# Devnet: https://api.devnet.solana.com
# Testnet: https://api.testnet.solana.com
# Mainnet Beta: https://api.mainnet-beta.solana.com

# Name for role account for solana 
ARG SOLANA_USER=solana

# Update package manager and install system packages  
RUN apt-get update && \
    apt-get install -y curl

# Install Nodejs v14 with npm and yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Create and use role account named "solana"
RUN useradd -rm -d /home/$SOLANA_USER -s /bin/bash -g root -G sudo -u 1001 $SOLANA_USER
USER $SOLANA_USER
WORKDIR /home/$SOLANA_USER
# Install & Configure Solana Core
RUN sh -c "$(curl -sSfL https://release.solana.com/v$SOLANA_VERSION/install)"
# Add solana excutables to the PATH
ENV PATH="/home/$SOLANA_USER/.local/share/solana/install/active_release/bin:$PATH"
# Configure specific solana network
RUN solana config set --url $SOLANA_CLUSTER_URL
