require "vworkapp_ruby"

describe VW::Base do

  before(:all) do
  end

  describe "#New" do

    it "Creates a base object from a given hash" do
      t = B1.new( 
        :a => "a",
        :b => "b",
        :c => {
          :one => "one",
          :two => "two"
        }
      )
      t.a.should == "a"
      t.b.should == "b"
      t.c.should be_instance_of B2
      t.c.one.should == "one"
      t.c.two.should == "two"
      t.d.should be_nil
    end

    it "Doesn't create setters for readonly attributes" do
      t = B1.new(:d => 'd')
      t.d.should == "d"
      lambda { t.d = 'ahem' }.should raise_error(NoMethodError)
    end

    it "Works with string keys too" do
      t = B1.new(:a => "a", "b" => "b")
      t.a.should == "a"
      t.b.should == "b"
    end

    it "Populates readonly attributes too" do
      t = B1.new(:d => "d")
      t.d.should == "d"
    end
        
    it "Works with array's of nested items" do
      t = B1.new(:es => [
        {:one => "one", :two => "two"},
        {:one => "three", :two => "four"}
      ])
      t.es.should be_instance_of Array
      t.es.size.should == 2
      t.es.first.should be_instance_of B2
      t.es.first.one.should == "one"
    end
    
  end

  describe "#Attributes" do

    it "Retuns the resources's attributes" do
      t = B1.new(:a => "a", :b => "b", :c => {:one => "one", :two => "two" })
      t.attributes.should == {
        "a" => "a",
        "b" => "b",
        "c" => B2.new(:one => "one", :two => "two"),
        "d" => nil,
        "es" => nil
      }
    end

    it "Retuns the resources's readable attributes" do
      t = B1.new(:a => "a", :b => "b", :d => 'd')
      t.read_attributes.should == {"a" => "a", "b" => "b", "c" => nil, "es" => nil, "d" => "d"}
    end

    it "Retuns the resources's writeable attributes" do
      t = B1.new(:a => "a", :b => "b", :d => 'd')
      t.write_attributes.should == {"a" => "a", "b" => "b", "c" => nil, "es" => nil}
    end

    it "Overwritten hattr setters get called" do
      t = B1.new
      class << t
        attr_reader :test
        def a=(value)
          @test = value
        end
      end
      t.attributes = {:a => "a"}
      t.test.should == "a"
    end

  end

  describe "#Equals" do
    it "Is == if key attributes match" do
      t1 = B1.new(:a => "a", :b => "b", :es => [{:one => "one", :two => "two"}, {:one => "three", :two => "four"}])
      t2 = B1.new(:a => "a", :b => "b", :es => [{:one => "one", :two => "two"}, {:one => "three", :two => "four"}])
      t1.should == t2
    end
  end

  describe "#Valdiations" do
    it "Has error(s) if required fields are missing" do
      @job = B1.new
      @job.valid?.should be_false
      @job.errors.keys.should == [:a]
    end
  end

  describe "Serialization" do

    # XXX fails intermittently because of hash ordering.
    it "Serializes into json" do
      t = B1.new(:a => "a", :b => "b", :es => [{:one => "one", :two => "two"}, {:one => "three", :two => "four"}])
      t.to_json.should == '{"b1":{"a":"a","b":"b","c":null,"es":[{"two":"two","one":"one"},{"two":"four","one":"three"}]}}'
    end

    # XXX fails intermittently because of hash ordering.
    it "Serializes into xml" do
      t = B1.new(:a => "a", :b => "b", :es => [{:one => "one", :two => "two"}, {:one => "three", :two => "four"}], :d => nil)
      t.to_xml.should == <<-eol
<?xml version="1.0" encoding="UTF-8"?>
<b1>
  <a>a</a>
  <b>b</b>
  <es type="array">
    <e>
      <two>two</two>
      <one>one</one>
    </e>
    <e>
      <two>four</two>
      <one>three</one>
    </e>
  </es>
  <c nil="true"></c>
</b1>
eol
    end

    it "Serializes into xml but doesn't include readonly items" do
      t = B1.new(:a => "a", :b => "b", :d => "d")
      t.to_xml.should_not include "<d>d</d>"
    end

    it "Serializes into json but doesn't include readonly items" do
      t = B1.new(:a => "a", :b => "b", :d => "d")
      t.to_json.should_not include '"d":"d"'
    end

  end

end

class B2 < VW::Base
  hattr_accessor :one, :two
  self.include_root_in_json = false
  
  def ==(other)
    attributes_eql?(other, :one, :two)
  end
end

class B1 < VW::Base
  hattr_accessor :a, :b, {:c => B2}, {:es => Array(B2)}
  hattr_reader :d

  validates_presence_of :a
  
  def ==(other)
    attributes_eql?(other, :a, :b, :c, :es)
  end
  
end
