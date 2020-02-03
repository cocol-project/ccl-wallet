module CCL::Wallet::Command
  module Generate
    extend self

    def call(options)
      wallet = CCL::Wallet::Store.read
      if !wallet.empty? && !options.bool["force"]
        puts "You already have a wallet. Use the '--force' flag to replace it\n" \
             "Wallet: #{wallet}"
        return
      end

      priv_key = CCL::Wallet::Store.write(CCL::Wallet.generate)
      puts "New private key: #{priv_key}"
    end
  end
end
