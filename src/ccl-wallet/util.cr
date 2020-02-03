module CCL::Wallet
  VERSION = "0.1.0"
  extend self

  alias PrivKey = String
  alias Address = String
  alias TxnHash = String

  def generate : PrivKey
    eth = Secp256k1::Ethereum::Account.new
    eth.get_secret
  end

  def address(priv_key) : Address
    Secp256k1::Ethereum.address_from_private(BigInt.new(priv_key, 16))
  end

  def sign(priv_key : PrivKey, txn_hash : TxnHash) : NamedTuple
    sig = Secp256k1::Signature.sign(txn_hash, BigInt.new(priv_key, 16))
    {r: sig.r, s: sig.s}
  end
end
