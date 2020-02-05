require "./deps"

cli = Commander::Command.new do |wallet|
  wallet.use = "ccl-wallet"
  wallet.long = "[WIP] Cocol Wallet - manage addresses and account balance"

  # --- ADDRESS
  wallet.commands.add do |addr|
    addr.use = "address"
    addr.short = "Show your address"
    addr.long = addr.short

    addr.run do |_options, _arguments|
      CCL::Wallet::Command::Address.call
    end
  end

  # --- SEND
  wallet.commands.add do |send|
    send.use = "send"
    send.short = "Transfer funds"

    send.flags.add do |flag|
      flag.name = "amount"
      flag.description = "The amount you want to transfer"
      flag.long = "--amount"
      flag.short = "-a"
      flag.default = 0
    end

    send.flags.add do |flag|
      flag.name = "recipient"
      flag.description = "Recipient address"
      flag.long = "--recipient"
      flag.short = "-r"
      flag.default = ""
    end

    send.flags.add do |flag|
      flag.name = "node"
      flag.description = "Node URI as 'host:port' (e.g. 127.0.0.1:3000)"
      flag.long = "--node"
      flag.short = "-n"
      flag.default = ""
    end

    send.run do |options, _arguments|
      CCL::Wallet::Command::Send.call(options)
    end
  end

  # --- GENERATE
  wallet.commands.add do |generate|
    generate.use = "generate"
    generate.short = "Generate a new wallet"

    generate.flags.add do |flag|
      flag.name = "force"
      flag.description = "Replaces old wallet. You will loose all funds!"
      flag.long = "--force"
      flag.short = "-f"
      flag.default = false
    end

    generate.run do |options, _arguments|
      CCL::Wallet::Command::Generate.call(options)
    end
  end
end

Commander.run(cli, ARGV)
