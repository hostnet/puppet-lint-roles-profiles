require 'spec_helper'

describe 'roles_include_profiles' do
  let(:msg) { 'roles must only `include profiles`' }
  [ 'role', 'roles' ].each do | rt |
    context "#{rt} without body" do
      let(:code) { "class #{rt}() {}" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    context "nested #{rt} without body" do
      let(:code) { "class #{rt}::example() {}" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    context "#{rt} including a profile" do
      let(:code) { "class #{rt}() { include profile::example }" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    context "#{rt} including a topscope profile" do
      let(:code) { "class #{rt}() { include ::profile::example }" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    context "#{rt} resource like profile" do
      let(:code) { "class #{rt}() { class { 'profile::example': } }" }
      it 'should be a problem' do
        expect(problems).to have(1).problem
      end
    end
    context "#{rt} with profiles mixed include and resource-like" do
      let(:code) do
        <<-EOL
class role::test {
  include profile::abc
  class { 'profile::def': }
  include profile::xyz
}
EOL
      end
      it 'should be a problem' do
        expect(problems).to have(1).problem
      end
    end
    context "#{rt} with non profiles mixed include and resource-like" do
      let(:code) do
        <<-EOL
class role::test {
  include profile::ssh
  include ssh::abc
  class { 'mysql::def': }
  include profile::xyz
  # include xyz
}
EOL
      end
      it 'should be a problem' do
        expect(problems).to have(2).problem
      end
    end
    context "#{rt} with conditional logic" do
      let(:code) do
        <<-EOL
class role::test {
  if $x == 1 {
    include profile::ssh
  } else {
    include ssh::abc
  }
  class { 'mysql::def': }
  include profile::xyz
  # include xyz
}
EOL
      end
      it 'should be a problem' do
        expect(problems).to have(4).problem
      end
    end
  end
end
