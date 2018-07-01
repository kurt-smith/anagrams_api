# frozen_string_literal: true

require 'rails_helper'

describe Anagramify do
  it { expect(subject.sort('rails')).to eq('ailrs') }
end
