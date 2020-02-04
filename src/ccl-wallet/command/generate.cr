module CCL::Wallet::Command
  module Generate
    extend self

    def call(options)
      priv_key = CCL::Wallet::Store.read
      if !priv_key.zero? && !options.bool["force"]
        puts "You already have a wallet. Use the '--force' flag to replace it\n" \
             "Wallet: #{priv_key}"
        return
      end

      new_priv_key = CCL::Wallet::Store.write(CCL::Wallet.generate)
      puts "New private key: #{new_priv_key}"
    end
  end
end
