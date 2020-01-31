require "secp256k1"
require "commander"
require "big"
require "json"
require "http/client"

module CCL::Wallet
  VERSION = "0.1.0"
  extend self

  alias PrivKey = String
  alias Address = String
  alias TxnHash = String

  def generate : PrivKey
    eth = Secp256k1::Ethereum::Account.new
    eth.get_secret
  end

  def address(priv_key) : Address
    pp priv_key
    Secp256k1::Ethereum.address_from_private(BigInt.new(priv_key, 16))
  end

  def sign(priv_key : PrivKey, txn_hash : TxnHash) : NamedTuple
    sig = Secp256k1::Signature.sign(txn_hash, BigInt.new(priv_key, 16))
    {r: sig.r, s: sig.s}
  end

  struct Signature
    include JSON::Serializable

    getter r : String
    getter s : String

    def initialize(@r, @s)
    end
  end

  abstract struct AbstractTransaction
    include JSON::Serializable

    getter hash : TxnHash
    getter amount : UInt64
    getter timestamp : Int64
    @[JSON::Field(emit_null: true)]
    property sig : Signature?

    private def calc_hash(*seed) : TxnHash
      sha = OpenSSL::Digest.new("SHA256")
      sha.update(seed.join(""))
      sha.hexdigest
    end
  end

  struct Transaction < AbstractTransaction
    getter from : String
    getter to : String

    def initialize(@from, @to, @amount)
      @timestamp = Time.utc.to_unix
      @hash = calc_hash(from, to, amount, timestamp)
    end
  end

  struct Stake < AbstractTransaction
    getter staker : String

    def initialize(@staker, @amount)
      @timestamp = Time.utc.to_unix
      @hash = calc_hash(staker, amount, timestamp)
    end
  end

  module Client
    extend self

    def post_transaction(node : String, txn : Transaction)
      res = HTTP::Client.post(
        "http://#{node}/transactions",
      headers: HTTP::Headers{
        "Content-Type" => "application/json",
        "UserAgent"    => "CCL-Wallet",
      },
        body: txn.to_json
      )

      pp res
    end
  end

  module Command
    module Send
      extend self

      def call(options)
        pp options
        if !options.int["amount"]
          puts "You must specify an amount (e.g. --amount 1)"
          return
        end
        if !options.string["recepient"]
          puts "You must specify the recepient (e.g. --recepient 0xd8eCB3556006A94298f09274Af15eB29e81329D5)"
          return
        end
        if !options.string["node"]
          puts "You must specify a node (e.g. --node 127.0.0.1:3000)"
          return
        end

        recepient_address = options.string["recepient"]
        amount = options.int["amount"]
        address = CCL::Wallet.address(CCL::Wallet::Store.read)
        node = options.string["node"]

        unsigned_txn = Transaction.new(
          from: address,
          to: recepient_address,
          amount: amount.to_u64
        )

        raw_signature = CCL::Wallet.sign(
          CCL::Wallet::Store.read,
          txn_hash: unsigned_txn.hash
        )
        signature = Signature.new(
          r: raw_signature[:r].to_s,
          s: raw_signature[:s].to_s
        )
        unsigned_txn.sig = signature
        signed_txn = unsigned_txn

        CCL::Wallet::Client.post_transaction(node, signed_txn)
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
        flag.default = 0
      end

      send.flags.add do |flag|
        flag.name = "recepient"
        flag.description = "Recepient address"
        flag.long = "--recepient"
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
end

Commander.run(cli, ARGV)
