# puppet-lint-roles-profiles

This plugin validates that the code base adheres to the roles and profiles
workflow[1].

## Installation

To use this plugin, add the following line to the Gemfile in your Puppet code
base and run `bundle install`.

```ruby
gem 'puppet-lint-roles-profiles'
```

## Usage

### roles_include_profiles

**--fix-support: No**

Will raise a warning if a roles does anything other than `include` `profile`s.
Resource like class definitions will also raise an error.

```
WARNING: roles must only include profiles
```

What you did:

```puppet
class role::foo {
  class { 'ssh': }
```

or:

```puppet
class role::foo {
  class { 'profile::ssh': }
}
```

What you should have done:

```
class role::foo {
  include profile::ssh
}
```

### roles_with_params

**--fix-support: No**

Will raise a warning when a role has class parameters

```
Warning: roles must not have any parameters
```

### roles_inherits_roles

**--fix-support: No**

Will raise a warning when a role inherits something other than a role

### nodes_include_one_role

**--fix-support: No**

Will raise a warning when a node definition contains more than one role
`include` (except comments).

## References

[1] https://puppet.com/docs/pe/2017.2/r_n_p_full_example.html

