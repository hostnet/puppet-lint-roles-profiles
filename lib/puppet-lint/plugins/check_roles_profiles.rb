PuppetLint.new_check(:roles_with_params) do
  def check
    class_indexes.select { |c| c[:name_token].value =~ /^roles?(::|$)/ }.each do |c|
      next if c[:param_tokens].nil?
      # breaks when roles have params that have variables as defaults
      c[:param_tokens].select { |t| t.type == :VARIABLE }.each do |t|
        notify :warning, {
          :message => 'roles must not have parameters',
          :line => t.line,
          :column => t.column,
        }
      end
    end
  end
end
