module CCL::Wallet::Command
  module Address
    extend self

    def call
      puts CCL::Wallet.address(CCL::Wallet::Store.read)
    end
  end
end
