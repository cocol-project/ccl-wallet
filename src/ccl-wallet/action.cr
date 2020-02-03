module CCL::Wallet::Action
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

  struct Transfer < AbstractTransaction
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
end
