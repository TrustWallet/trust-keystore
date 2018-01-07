Pod::Spec.new do |s|
  s.name         = 'TrustKeystore'
  s.version      = '0.0.2'
  s.summary      = 'A general-purpose Ethereum keystore for managing wallets.'
  s.homepage     = 'https://github.com/TrustWallet/trust-keystore'
  s.license      = 'GPL'
  s.authors      = { 'Alejandro Isaza' => 'al@isaza.ca' }
  
  s.ios.deployment_target = '8.0'

  s.source       = { git: 'https://github.com/TrustWallet/trust-keystore.git', tag: s.version }
  s.source_files = "Sources"

  s.dependency 'CryptoSwift'
  s.dependency 'secp256k1'

  s.pod_target_xcconfig = { 'SWIFT_OPTIMIZATION_LEVEL' => '-Owholemodule' }
end
