module CCL::Wallet
  extend self

  alias PrivKey = BigInt
  alias Address = String
  alias TxnHash = String
  alias PubCompressed = String
  alias Signature = Secp256k1::Signature

  def generate : String
    eth = Secp256k1::Ethereum::Account.new
    eth.get_secret
  end

  def address : Address
    Secp256k1::Ethereum.address_from_private(priv_key)
  end

  def sign(input : TxnHash) : CCL::Wallet::Action::Signature
    s = Secp256k1::Signature.sign(input, priv_key)

    CCL::Wallet::Action::Signature.new(
      v: pub_compressed,
      r: s.r.to_s,
      s: s.s.to_s
    )
  end

  def pub_compressed : PubCompressed
    pub = Secp256k1::Util.public_key_from_private(priv_key)
    Secp256k1::Util.public_key_compressed_prefix(pub)
  end

  private def priv_key
    CCL::Wallet::Store.read
  end
end
