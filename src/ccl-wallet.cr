require "secp256k1"
require "commander"
require "big"
require "json"

module CCL::Wallet
  VERSION = "0.1.0"
  extend self

  alias PrivKey = String
  alias Address = String

  def generate : PrivKey
    eth = Secp256k1::Ethereum::Account.new
    eth.get_secret
  end

  module Command
    module Send
      extend self

      def call(options)
        if !options.int["amount"]
          puts "You must specify an amount (e.g. --amount 1)"
          return
        end
        if !options.int["recepient"]
          puts "You must specify the recipient (e.g. --recepient 0xd8eCB3556006A94298f09274Af15eB29e81329D5)"
          return
        end
        if !options.string["node"]
          puts "You must specify a node (e.g. --recepient 127.0.0.1:3000)"
          return
        end

        recepient_address = options.string["recepient"]

        # POST unsigned transaction and receive the hash
        # sign the hash
        # PUT finish transaction
      end

      def address : Address
        @@address ||= Secp256k1::Ethereum.address_from_private(
          BigInt.new(CCL::Wallet::Store.read, 16)
        )
      end
    end

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

cli = Commander::Command.new do |base|
  base.use = "ccl-wallet"
  base.long = "[WIP] Cocol Wallet - manage addresses and account balance"

  # --- WALLET
  base.commands.add do |wallet|
    wallet.use = "wallet"
    wallet.short = "Wallet stuff"
    wallet.long = wallet.short

    wallet.commands.add do |send|
      send.use = "send"
      send.short = "Transfer funds"

      send.flags.add do |flag|
        flag.name = "amount"
        flag.description = "The amount you want to transfer"
        flag.long = "--amount"
        flag.short = "-a"
      end

      send.flags.add do |flag|
        flag.name = "recepient"
        flag.description = "Recepient address"
        flag.long = "--recepient"
        flag.short = "-r"
      end

      send.flags.add do |flag|
        flag.name = "node"
        flag.description = "Node URI as 'host:port' (e.g. 127.0.0.1:3000)"
        flag.long = "--node"
        flag.short = "-n"
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
end

Commander.run(cli, ARGV)
