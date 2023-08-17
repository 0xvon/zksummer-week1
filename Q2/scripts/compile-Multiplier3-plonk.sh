#!/bin/bash

cd contracts/circuits

mkdir _plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."

# compile circuit

circom Multiplier3.circom --r1cs --wasm --sym -o _plonk
snarkjs r1cs info _plonk/Multiplier3.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup _plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonk/circuit_final.zkey
# snarkjs plonk setup _plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonk/circuit_0000.zkey
# snarkjs zkey contribute _plonk/circuit_0000.zkey _plonk/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
# snarkjs zkey export verificationkey _plonk/circuit_final.zkey _plonk/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier _plonk/circuit_final.zkey ../Multiplier3-Plonk.sol

cd ../..