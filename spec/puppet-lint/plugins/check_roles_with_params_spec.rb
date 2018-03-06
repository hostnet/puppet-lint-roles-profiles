require 'spec_helper'

describe 'roles_with_params' do
  let(:msg) { 'roles must not have parameters' }
  [ 'role', 'roles' ].each do | rt |
    context "#{rt} without body" do
      let(:code) { "class #{rt}() {}" }
      it 'should not be a problem' do
        expect(problems).to have(0).problem
      end
    end
    context "#{rt} with attr" do
      let(:code) { "class #{rt}($er) {}" }
      it 'should be a problem' do
        expect(problems).to have(1).problem
        expect(problems).to contain_warning(msg).on_line(1)
      end
    end
    context "#{rt} without body" do
      let(:code) { "class #{rt}($er, $er2) {}" }
      it 'should be a problem' do
        expect(problems).to have(2).problem
      end
    end
    context "#{rt} with typed and default attrs" do
      let(:code) do
        <<-EOL
class role::test (
  $attr,
  String $attr2,
  Optional[Variant[Integer,String]] $attr3 = 'test',
) {
}
EOL
      end
      it 'should be a problem' do
        expect(problems).to have(3).problem
        expect(problems).to contain_warning(msg).on_line(2)
        expect(problems).to contain_warning(msg).on_line(3)
        expect(problems).to contain_warning(msg).on_line(4)
      end
    end
  end
end
