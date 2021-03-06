# -*- encoding: utf-8 -*-

require 'test_helper'
require 'hexapdf/document'
require 'hexapdf/type/annotations/text'

describe HexaPDF::Type::Annotations::Text do
  before do
    @doc = HexaPDF::Document.new
    @doc.version = '1.5'
    @annot = HexaPDF::Type::Annotations::Text.new({Rect: [0, 0, 1, 1]}, document: @doc)
  end

  describe "validation" do
    it "checks for correct /StateModel values" do
      @annot[:StateModel] = 'Invalid'
      refute(@annot.validate {|msg| assert_match(/contains invalid value/, msg)})
    end

    it "automatically sets /StateModel based on the /State entry if possible" do
      @annot[:State] = 'Marked'
      assert(@annot.validate)
      assert_equal('Marked', @annot[:StateModel])

      @annot.delete(:StateModel)
      @annot[:State] = 'Unknown'
      refute(@annot.validate {|msg| assert_match(/StateModel required/, msg)})
    end

    it "checks whether /State and /StateModel match" do
      @annot[:State] = 'Marked'
      @annot[:StateModel] = 'Marked'
      assert(@annot.validate)
      @annot[:StateModel] = 'Review'
      refute(@annot.validate {|msg| assert_match(/\/State and \/StateModel don't agree/, msg)})
    end
  end
end
