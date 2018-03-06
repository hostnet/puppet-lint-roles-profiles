require 'spec_helper'

describe 'nodes_include_one_role' do
  let(:msg) { 'nodes must only include roles' }
  context 'node with role' do
    let(:code) { 'node /some.machine/ { include role::ssh }' }
    it 'should not be a problem' do
      expect(problems).to have(0).problem
    end
  end
  context 'node with profile' do
    let(:code) { 'node /some.machine/ { include profile::ssh }' }
    it 'should be a problem' do
      expect(problems).to have(1).problem
    end
  end
  context "node with multiple roles" do
    let(:code) do
      <<-EOL
node 'somemachine' {
  include role::ssh
  include role::ssh2
}
EOL
    end
    it 'should be a problem' do
      expect(problems).to have(1).problem
    end
  end
  context "node with multiple inline comments" do
    let(:code) do
      <<-EOL
node 'somemachine' {
# good descriptions
# go here
  include role::ssh
# and here
# more
}
EOL
    end
    it 'should not be a problem' do
      expect(problems).to have(0).problem
    end
  end
  context "node with comments and multiple includes" do
    let(:code) do
      <<-EOL
# comments
node 'somemachine' {
# good descriptions
# go here
  include role::ssh
# and here
  include profile::ssh
# more
}
EOL
    end
    it 'should be a problem' do
      expect(problems).to have(1).problem
    end
  end
end
