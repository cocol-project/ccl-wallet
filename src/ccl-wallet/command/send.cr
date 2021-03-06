module CCL::Wallet::Command
  module Send
    extend self

    def call(options)
      if !options.int["amount"]
        puts "You must specify an amount (e.g. --amount 1)"
        return
      end
      if !options.string["recipient"]
        puts "You must specify the recipient (e.g. --recipient 0xd8eCB3556006A94298f09274Af15eB29e81329D5)"
        return
      end
      if !options.string["node"]
        puts "You must specify a node (e.g. --node 127.0.0.1:3000)"
        return
      end

      recipient_address = options.string["recipient"]
      amount = options.int["amount"]
      address = CCL::Wallet.address
      node = options.string["node"]

      unsigned_transfer = CCL::Wallet::Action::Transfer.new(
        from: address,
        to: recipient_address,
        amount: amount.to_u64
      )

      signature = CCL::Wallet.sign(unsigned_transfer.hash)
      unsigned_transfer.sig = signature
      signed_transfer = unsigned_transfer

      CCL::Wallet::Client.post(signed_transfer, to: node)
    end
  end
end
