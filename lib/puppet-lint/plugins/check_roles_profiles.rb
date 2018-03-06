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

PuppetLint.new_check(:roles_include_profiles) do
  def check
    class_indexes.select { |c| c[:name_token].value =~ /^roles?(::|$)/ }.each do |c|
      # As only `include profile` is allowed any resource is bad
      resource_indexes.select { |r| r[:start] >= c[:start] and r[:end] <= c[:end] }.each do |r|
        notify :warning, {
          :message => "Roles must only `include profiles`",
          :line => r[:type].line,
          :column => r[:type].column,
        }
      end
      # each include must be followed with a profile
      tokens[c[:start]..c[:end]].select { |t| t.value == 'include' }.each do |t|
        unless t.next_code_token.value =~ /^(::)?profiles?(::|$)/
          notify :warning, {
            :message => "Roles must only `include profiles`",
            :line => t.line,
            :column => t.column
          }
        end
      end
      # Conditional logic should be avoided
      tokens[c[:start]..c[:end]].select { |t| [ :IF, :ELSE, :ELSIF, :UNLESS, :CASE].include?(t.type) }.each do |t|
        notify :warning, {
          :message => "Roles must only `include profiles`",
          :line => t.line,
          :column => t.column
        }
      end
    end
  end
end

PuppetLint.new_check(:roles_inherits_roles) do
  def check
    class_indexes.select { |c| c[:name_token].value =~ /^roles?(::|$)/ }.each do |c|
      if c[:inherited_token] and ! (c[:inherited_token].value =~ /^(::)?roles?(::|$)/)
        notify :warning, {
          :message => "Roles must only inherit other roles",
          :line => c[:inherited_token].line,
          :column => c[:inherited_token].column
        }
      end
    end
  end
end
 
