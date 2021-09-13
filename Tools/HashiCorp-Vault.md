# HashiCorp Vault

[HashiCorp Vault](https://www.vaultproject.io/) can be used to store things like passwords, certificates and encryption keys.

## Usage

### CLI
Login to a vault server with a token
`vault login -address=https://vault.net -method=token`

List kv entries
`vault kv list network/services`

Get a kv entry
`vault get network/services/ipam`

## Links
- [Awesome Vault Tools](https://github.com/gites/awesome-vault-tools)