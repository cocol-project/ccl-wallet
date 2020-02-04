# [WIP] Cocol Wallet 🌐

[![Build Status](https://img.shields.io/github/workflow/status/cocol-project/ccl-wallet/weekly)](https://github.com/cocol-project/ccl-wallet/actions) ![Stability Experimental](https://img.shields.io/badge/Stability-Experimental-orange.svg?style=flat-square) ![Crystal 0.32.1](https://img.shields.io/badge/Crystal-0.32.1-blue.svg?style=flat-square&link=https://crystal-lang.org&link=https://crystal-lang.org/api/0.32.1/) ![License MPL-2.0](https://img.shields.io/badge/License-MPL--2.0-green.svg?style=flat-square)

Official wallet for the cocol network.

It is still:
- work in progress
- not safe
- not tested


## Installation 🏹

Cocol Wallet is written in [Crystal](https://crystal-lang.org/), so make sure to follow the [installation instructions](https://crystal-lang.org/reference/installation/) first.

After setting up Crystal you can clone the repository and build it:
```shell
> git clone https://github.com/cocol-project/ccl-wallet.git
> cd ccl-wallet
> make
```

## Usage ⚔

```shell
> ./bin/ccl-wallet help

  ccl-wallet - [WIP] Cocol Wallet - manage addresses and account balance

  Usage:
    ccl-wallet [command] [arguments]

  Commands:
    address         # Show your address
    generate        # Generate a new wallet
    help [command]  # Help about any command.
    send            # Transfer funds

  Flags:
    -h, --help  # Help for this command. default: 'false'.
```

Let's create a wallet and transfer some funds:

``` shell
> ./bin/ccl-wallet generate
New private key: 7e704ced1d4dc06bc2fff284d155a46886492ac158f0b4719ff7e7ca3f43a806

# show my address
> ./bin/ccl-wallet address
0x15C91b5CBE385dd8a94643Db2021A92E0D3b6F65

> ./bin/ccl-wallet send --amount 100 --recepient 0x5432FD4A91c46d3F8DAEd3cC79C8a85a77764c3a --node 127.0.0.1:3000
Success!
```

Note: You have to give yourself some $ccl in the genesis block (premine it)
otherwise the node won't accept your transfer as valid. Right now you have to do
it manually by changing the address in the `genesis_transactions` method in the
cocol codebase

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/cocol-project/ccl-wallet/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Cristian Șerb](https://github.com/cserb) - creator and maintainer
