require 'test/unit'
require 'xml/libxml/feed'
require 'stringio'

class TestAST < Test::Unit::TestCase
    def test_ast_interface
        ast = nil

        assert_nothing_raised do 
            ast = XML::Feed::Parser::AST.new("test")
        end

        assert_nothing_raised do
            ast.add_ast XML::Feed::Parser::AST.new("test")
        end

        assert_raise(XML::Feed::Parser::AST::TypeError) do
            ast.add_ast Array.new
        end

        assert_raise(XML::Feed::Parser::AST::TypeError) do
            ast.set_attribute [], "stuff"
        end

        assert_nothing_raised do
            ast.set_attribute "stuff", self.class
        end

        assert_equal("<AST test: [arguments: <AST test: [arguments: ] - [ attributes: ]>] - [ attributes: stuff:TestAST]>", ast.inspect)
    end
end
