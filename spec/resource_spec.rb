require "vworkapp_ruby"

describe VW::Resource do

  before(:all) do
  end

  describe "#From Hash" do

    it "Creates a resource from a given hash" do
      t = Test.from_hash({ 
        :a => "a",
        :b => "b",
        :c => {
          :one => "one",
          :two => "two"
        }
      })
      t.a.should == "a"
      t.b.should == "b"
      t.c.one.should == "one"
      t.c.two.should == "two"
      t.d.should be_nil
    end

    it "Works with string keys too" do
      t = Test.from_hash({ :a => "a", "b" => "b" })
      t.a.should == "a"
      t.b.should == "b"
    end

    it "Populates readonly attributes too" do
      t = Test.from_hash({ :d => "d" })
      t.d.should == "d"
    end
    
    it "Doesn't include attributes that are nil" do
      t = Test.from_hash({ 
        :a => "a",
        :b => nil,
        :c => nil
      })
      t.a.should == "a"
      t.b.should be_nil
      t.c.should be_nil
    end
    
    it "Works with array's of nested items" do
      t = Test.from_hash({:e => [
        {:one => "one", :two => "two"},
        {:one => "three", :two => "four"}
      ]})
      t.e.should be_instance_of Array
      t.e.size.should == 2
      
    end
    
  end

  describe "#To Hash" do

    it "Serializes a resource into a hash" do
      t = Test.new("a", "b", Test2.new("one", "two"))
      t.to_hash.should == { 
        :a => "a",
        :b => "b",
        :c => {
          :one => "one",
          :two => "two"
        }
      }
    end

    it "Doesn't include attributes that are nil" do
      t = Test.new("a", nil, nil)
      t.to_hash.should == {
        :a => "a"
      }
    end
  
    it "Works with array's too" do
      t = Test.new("a", "b", nil)
      t.e = [
        Test2.new("one", "two"),
        Test2.new("three", "four"),
      ]

      t.to_hash.should == {
        :a => "a",
        :b => "b",
        :e => [
          { :one => "one", :two => "two" },
          { :one => "three", :two => "four" }
        ]
      }
    end

  end

end

class Test < VW::Resource
  attr_accessor :a, :b, :c, :e
  attr_reader :d
  def initialize(a, b, c)
    @a, @b, @c = a, b, c
  end
  def attributes
    [:a, :b, {:c => Test2}, :d, {:e => Array(Test2)}]
  end
end

class Test2 < VW::Resource
  attr_accessor :one, :two
  def initialize(one, two)
    @one, @two = one, two 
  end
  def attributes
    [:one, :two]
  end
end
