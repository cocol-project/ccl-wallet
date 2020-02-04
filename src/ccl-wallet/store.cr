module CCL::Wallet
  module Store
    extend self
    WALLET_FILE = "./wallet"

    def write(priv_key : String) : String
      File.write(WALLET_FILE, priv_key)
      priv_key
    end

    def read : PrivKey
      priv_key_hex = File.read(WALLET_FILE)
      return BigInt.new(0) if priv_key_hex.empty?

      BigInt.new(priv_key_hex, 16)
    end
  end
end
