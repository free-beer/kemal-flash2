require "../spec_helper"

Spectator.describe Kemal::Flash2::FlashStore do
  let(base_values) {
    {"FIRST"  => "One",
     "SECOND" => "2",
     "THIRD"  => "3.33"}
  }

  describe "constructions" do
    describe "without parameters" do
      it "creates an empty store" do
        store = Kemal::Flash2::FlashStore.new
        expect(store.size).to eq (0)
      end
    end

    describe "with parameters" do
      it "creates a prepopulated store" do
        store = Kemal::Flash2::FlashStore.new(base_values)
        expect(store.size).to eq (3)
      end
    end
  end

  describe "#has_key?()" do
    it "returns false if the key exists within the store" do
      store = Kemal::Flash2::FlashStore.new
      expect(store.has_key?("NOPE")).to be_false
    end

    it "returns true if the key exists within the store" do
      store = Kemal::Flash2::FlashStore.new(base_values)
      expect(store.has_key?("FIRST")).to be_true
      expect(store.has_key?("SECOND")).to be_true
      expect(store.has_key?("THIRD")).to be_true
    end
  end

  describe "#fetch()" do
    describe "when the requested key exists" do
      describe "and an alternative is not present" do
        it "returns the value associated with the key" do
          store = Kemal::Flash2::FlashStore.new(base_values)
          expect(store.fetch("SECOND")).to eq("2")
        end
      end

      describe "and an alternative is present" do
        it "returns the value associated with the key" do
          store = Kemal::Flash2::FlashStore.new(base_values)
          expect(store.fetch("THIRD", "ALTERNATIVE")).to eq("3.33")
        end
      end
    end

    describe "when the requested key does not exist" do
      describe "and an alternative is not present" do
        it "returns the default alternative" do
          store = Kemal::Flash2::FlashStore.new
          expect(store.fetch("SECOND")).to eq("")
        end
      end

      describe "and an alternative is present" do
        it "returns the alternative value specified" do
          store = Kemal::Flash2::FlashStore.new
          expect(store.fetch("THIRD", "ALTERNATIVE")).to eq("ALTERNATIVE")
        end
      end
    end
  end

  describe "#to_s()" do
    describe "when the only data present comes from the constructor" do
      it "generates a string equivalent of the hash initialization data" do
        store = Kemal::Flash2::FlashStore.new(base_values)
        expect(store.to_s).to eq(base_values.to_s)
      end
    end

    describe "when there is data from construction and from after construction" do
      it "returns a stringified hash of the data with the later data taking priority" do
        store = Kemal::Flash2::FlashStore.new(base_values)
        store["SECOND"] = "CHANGED!"
        store["NEW"] = "NewValue"
        expect(store.to_s).to eq(base_values.merge({"SECOND" => "CHANGED!", "NEW" => "NewValue"}).to_s)
      end
    end
  end

  describe "#[]()" do
    it "returns the associated value when the key exists" do
      store = Kemal::Flash2::FlashStore.new(base_values)
      expect(store["FIRST"]).to eq("One")
      expect(store["SECOND"]).to eq("2")
      expect(store["THIRD"]).to eq("3.33")
    end

    it "raises an exception when the key does not exist" do
      store = Kemal::Flash2::FlashStore.new
      expect { store["NOPE"] }.to raise_error("A flash entry under the key 'NOPE' could not be found.")
    end
  end

  describe "#[]=()" do
    it "assigns the value in flash if it does not already exist" do
      store = Kemal::Flash2::FlashStore.new
      store["TEST_KEY"] = "TEST_VALUE"
      expect(store.fetch("TEST_KEY")).to eq("TEST_VALUE")
    end

    it "overwrites the value in flash if it does already exist" do
      store = Kemal::Flash2::FlashStore.new({"TEST_KEY" => "OLD_VALUE"})
      store["TEST_KEY"] = "TEST_VALUE"
      expect(store.fetch("TEST_KEY")).to eq("TEST_VALUE")
    end

    it "makes the newly assigned value part of the content for the next request" do
      store = Kemal::Flash2::FlashStore.new
      store["TEST_KEY"] = "TEST_VALUE"
      expect(store.following.keys).to contain("TEST_KEY")
      expect(store.following["TEST_KEY"]).to eq("TEST_VALUE")

      store = Kemal::Flash2::FlashStore.new({"TEST_KEY" => "OLD_VALUE"})
      store["TEST_KEY"] = "TEST_VALUE"
      expect(store.following.keys).to contain("TEST_KEY")
      expect(store.following["TEST_KEY"]).to eq("TEST_VALUE")
    end
  end

  describe "FlashStore.from()" do
    it "constructs a flash store from a JSON::Any object" do
      store = Kemal::Flash2::FlashStore.from(JSON.parse(base_values.to_json))
      expect(store["FIRST"]).to eq("One")
      expect(store["SECOND"]).to eq("2")
      expect(store["THIRD"]).to eq("3.33")
    end
  end
end
