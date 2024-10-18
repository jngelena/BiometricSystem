# Blockchain E-Voting System Using Face Recognition

The goal of this project is to create a secure e-voting system that uses face recognition for biometric verification and blockchain technology for vote integrity and transparency. The app allows voters to register, authenticate, and cast their votes securely through their mobile devices.

## Features
- **Biometric Authentication**: Uses face recognition technology for voter registration and authentication.
- **Anti-Spoofing Measures**: Integrates the m7 liveness detection package to prevent spoofing attacks.
- **Blockchain Integration**: Ensures the immutability of votes and voter anonymity using blockchain smart contracts.
- **Secure and Anonymous Voting**: Implements cryptographic methods to protect voter identities and secure transaction data.

## Technologies Used
- **Flutter**: The mobile app is developed using Flutter, providing a multi-platform and natively compiled user experience.
- **Face Recognition**: Uses the GhostFaceNet model through the Deepface framework for facial recognition and authentication.
- **Blockchain**: Utilizes Solidity smart contracts on the Ethereum blockchain to ensure the integrity and immutability of the voting process.
- **Firebase**: Stores user data securely in a NoSQL cloud database.
- **web3dart**: A Dart library used for interacting with Ethereum blockchain nodes.

## Application Architecture
1. **Sign Up**: Users register by providing their facial data, which is captured and stored using Deepface. Anti-spoofing checks are performed during the registration process.
2. **Login**: The app performs a liveness detection check before granting access to registered users, ensuring that the login attempt is genuine.
3. **Voting**: Registered users can cast their votes through a blockchain-based DApp, ensuring that each vote is immutable and anonymously recorded.

## Blockchain Implementation
- The app interacts with the blockchain to manage voter registration and record votes using unique IDs.
- Votes are cast on the Sepolia testnet, allowing for rigorous testing of smart contracts and decentralized applications.
- Smart contracts ensure that each voter can only cast a single vote per event.

## Getting Started
### Prerequisites
- Flutter SDK installed on your development machine
- Firebase account setup for backend services
- Access to the Sepolia testnet for blockchain deployment

## References
- [Deepface Framework](https://github.com/serengil/deepface)
- [m7 Liveness Detection](https://pub.dev/packages/m7_livelyness_detection)
- [Solidity Documentation](https://soliditylang.org/)
- [web3dart Package](https://pub.dev/packages/web3dart)
