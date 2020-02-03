module CCL::Wallet
  module Client
    extend self

    def post_transaction(node : String, txn : CCL::Wallet::Action::Transfer)
      res = HTTP::Client.post(
        "http://#{node}/transactions",
        headers: HTTP::Headers{
          "Content-Type" => "application/json",
          "UserAgent"    => "CCL-Wallet",
        },
        body: txn.to_json
      )

      puts "Success!" if res.success?
      puts "Failed\n" \
           "\n" \
           "#{res.body}" if !res.success?
    end
  end
end
