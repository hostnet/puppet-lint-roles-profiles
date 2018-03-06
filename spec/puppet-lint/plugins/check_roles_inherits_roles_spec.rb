require 'spec_helper'

describe 'roles_inherits_roles' do
  let(:msg) { 'roles must only `include profiles`' }
  [ 'role', 'roles' ].each do | rt |
    context "#{rt} without inherit" do
      let(:code) { "class #{rt}() {}" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    [
      [ "role", 0 ],
      [ "roles", 0 ],
      [ "profile", 1 ],
      [ "ssh", 1 ],
      [ "::role", 0 ],
      [ "::roles", 0 ],
      [ "::role::ssh", 0 ],
      [ "rolex", 1 ],
    ].each do | data |
      context "#{rt} with inherit #{data[0]}" do
        let(:code) { "class #{rt} inherits #{data[0]}{}" }
        it { expect(problems).to have(data[1]).problem }
      end 
    end
  end
end
