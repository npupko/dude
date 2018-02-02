require 'byebug'
require 'spec_helper'

RSpec.describe Dude do
  it "has a version number" do
    expect(Dude::VERSION).not_to be nil
  end
end
