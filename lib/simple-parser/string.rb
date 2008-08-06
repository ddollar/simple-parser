module SimpleParser::String
  
  def self.included(base)
    base.send(:define_method, :parse) do |format|
      SimpleParser::String::parse(self, format)
    end
  end
  
  @parser_cache = {}
  
  def self.parse(string, format)
    parser = @parser_cache[format] || SimpleParser::String::build_parser(format)
    
    matches = string.match(parser[:regexp]).to_a
    matches.shift

    parser[:tokens].inject({}) do |memo, token|
      memo[token.intern] = matches.shift
      memo
    end
  end
  
  private
  
  def self.build_parser(format)
    tokens = format.scan(/\:\w*/).map { |token| token[1..-1] }

    regexp_builder = "^#{Regexp.escape(format)}$"

    tokens.each do |token|
      regexp_builder.gsub!(":#{token}", '(.*?)')
    end
  
    regexp = Regexp.new(regexp_builder)
    
    @parser_cache[format] = { :tokens => tokens, :regexp => regexp }
  end
  
end