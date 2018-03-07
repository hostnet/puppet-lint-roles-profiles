Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-roles-profiles'
  spec.version     = '0.0.1'
  spec.homepage    = 'https://github.com/hostnet/puppet-lint-roles-profiles'
  spec.license     = 'MIT'
  spec.author      = 'Hostnet'
  spec.email       = 'opensource@hostnet.nl'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'puppet-lint check to validate that the codebase adheres to the roles and profiles workflow'
  spec.description = <<-EOF
    This puppet-lint extension validates that:
    - node definitions only `include` a single role
    - roles only `include` profiles and have no class parameters
    - roles only `inherit` other roles
  EOF

  spec.add_dependency             'puppet-lint', '>= 1.1', '< 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake'
end
