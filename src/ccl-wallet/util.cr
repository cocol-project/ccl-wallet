module CCL::Wallet
  VERSION = "0.1.0"
  extend self

  alias PrivKey = BigInt
  alias Address = String
  alias TxnHash = String
  alias PubCompressed = String

  def generate : String
    eth = Secp256k1::Ethereum::Account.new
    eth.get_secret
  end

  def address(from priv_key : PrivKey) : Address
    Secp256k1::Ethereum.address_from_private(priv_key)
  end

  def sign(txn_hash : TxnHash, with priv_key : PrivKey) : NamedTuple
    sig = Secp256k1::Signature.sign(txn_hash, priv_key)
    {r: sig.r, s: sig.s}
  end

  def pub_compressed(from priv_key : PrivKey) : PubCompressed
    pub = Secp256k1::Util.public_key_from_private(priv_key)
    Secp256k1::Util.public_key_compressed_prefix(pub)
  end
end
