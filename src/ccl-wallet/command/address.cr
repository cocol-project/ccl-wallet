module CCL::Wallet::Command
  module Address
    extend self

    def call
      puts CCL::Wallet.address
    end
  end
end
