require "spec_helper"

module DeviseLoginCookie

  describe Cookie do

    include DeviseLoginCookie::SpecHelpers


    describe "#unset" do
      it "deletes cookie" do
        options = { :path => "/a", :domain => "a.bc", :secure => true, :httponly => true }
        jar = double().tap do |jar|
          jar.should_receive(:delete).with(:test_token, options)
        end
        Cookie.new(jar, :test).tap{ |c| c.session_options = options }.unset
      end
    end

    describe "without any cookies" do
      let(:cookie) { create_cookie }
      subject { cookie }

      describe "Cookie instance" do
        it { should_not be_valid }
        it { should_not be_set_since(Time.at(0)) }
      end

    end

    describe "with an invalid cookie" do
      let(:cookie) { create_cookie :test_token => "blarg" }
      subject { cookie }

      describe "Cookie instance" do
        it { should_not be_valid }
        it { should_not be_set_since(Time.at(0)) }
      end

      describe "#set" do
        it "accepts resource" do
          cookie.set(resource(10))
          cookie.id.should == 10
        end
      end
    end

    describe "with a valid cookie" do
      # force integer precision, rather than float.
      let(:now) { Time.at(Time.now.to_i) }
      let(:cookie) { create_valid_cookie(5, now) }
      subject { cookie }

      describe "Cookie instance" do
        it { should be_valid }
        it { should_not be_set_since(now + 1) }
        it { should be_set_since(now) }
        it { should be_set_since(now - 1) }
      end

      describe "#id" do
        subject { cookie.id }
        it { should == 5 }
      end

      describe "#created_at" do
        subject { cookie.created_at }
        it { should == now }
      end

      describe "#set" do
        it "accepts resource" do
          cookie.set(resource(10))
          cookie.id.should == 10
        end
      end
    end

  end

end
