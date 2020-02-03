module CCL::Wallet
  module Store
    extend self
    WALLET_FILE = "./wallet"

    def write(priv_key : PrivKey) : PrivKey
      File.write(WALLET_FILE, priv_key)
      priv_key
    end

    def read : PrivKey
      File.read(WALLET_FILE)
    end
  end
end
