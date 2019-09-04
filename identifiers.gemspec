Gem::Specification.new do |spec|
  spec.name          = 'identifiers'
  spec.version       = '0.12.1'
  spec.authors       = ['Jonathan Hernandez', 'Paul Mucur']
  spec.email         = ['support@altmetric.com']

  spec.summary       = 'Utilities library for various scholarly identifiers used by Altmetric'
  spec.homepage      = 'https://github.com/altmetric/identifiers'
  spec.license       = 'MIT'

  spec.files         = Dir['*.{md,txt}', 'lib/**/*.rb']
  spec.test_files    = Dir['spec/**/*.rb']
  spec.bindir        = 'exe'

  spec.add_dependency 'urn', '~> 2.0'

  spec.add_development_dependency('rake', '~> 10.0')
  spec.add_development_dependency('rspec', '~> 3.4')
end
