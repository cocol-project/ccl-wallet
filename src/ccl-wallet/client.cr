module CCL::Wallet
  module Client
    extend self

    def post(transfer : CCL::Wallet::Action::Transfer, to node : String)
      res = HTTP::Client.post(
        "http://#{node}/transactions",
        headers: HTTP::Headers{
          "Content-Type" => "application/json",
          "UserAgent"    => "CCL-Wallet",
        },
        body: transfer.to_json
      )

      puts "Success!" if res.success?
      puts "Failed\n" \
           "\n" \
           "#{res.body}" if !res.success?
    end
  end
end
