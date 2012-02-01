require "vworkapp_ruby"
require 'support/active_model_lint'

describe VW::Resource do

  before(:all) do
  end

  subject { t = R1.new(
    :a => "a", :b => "b",
    :c => {
      :one => "one",
      :two => "two"
    })
  }
  
  it_should_behave_like "ActiveModel"

end

class R2 < VW::Resource
  hattr_accessor :one, :two
  self.include_root_in_json = false
  
  def ==(other)
    attributes_eql?(other, :one, :two)
  end
end

class R1 < VW::Resource
  hattr_accessor :a, :b, {:c => R2}, {:es => Array(R2)}
  hattr_reader :d
  
  def ==(other)
    attributes_eql?(other, :a, :b, :c, :es)
  end
end
