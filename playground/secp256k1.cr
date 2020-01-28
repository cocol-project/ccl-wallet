require "secp256k1"

# generates an ethereum account from the keypair
eth = Secp256k1::Ethereum::Account.new

# gets the private key
priv = eth.get_secret
privr=BigInt.new(priv, 16)
pubr=Secp256k1::Util.public_key_from_private(privr)

# gets the ethereum addresss
pub = Secp256k1::Ethereum.address_from_private(privr)
msg = "Hello, World; I am and #{pub}!"
sig = Secp256k1::Signature.sign(msg, privr)
valid = Secp256k1::Signature.verify(msg, sig, pubr)
