require_relative 'support/int_helper'

#TODO test that containers, partials, scopes reference same nodes? so that when
# one is modified it modifies the other?

describe Pakyow::Presenter::StringDoc do
  def node_from_doc(doc)
    doc
  end

  let :doctype do
    Pakyow::Presenter::StringDoc
  end

  describe '#initialize' do
    it 'parses html with StringDocParser' do
      skip
    end

    it 'sets instance variables with values from parser' do
      skip
    end
  end

  include_examples :doc_specs
  include_examples :scope_specs
  include_examples :attr_specs
  include_examples :repeating_specs
  include_examples :matching_specs
  include_examples :building_specs
  include_examples :binding_specs
end
