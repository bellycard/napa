require 'active_record'
require 'spec_helper'
require 'napa/sortable_api'

describe "SortableApi" do
  describe "#sort_from_params" do
    before do
      build_model :foos do
        integer :param1
        integer :param2
      end

      @object1 = Foo.create(param1: 2, param2: 1)
      @object2 = Foo.create(param1: 2, param2: 3)
      @object3 = Foo.create(param1: 3, param2: 5)
      @object4 = Foo.create(param1: 1, param2: 3)
      @object5 = Foo.create(param1: 1, param2: 1)

      @api = Object.new
      @api.extend(Napa::SortableApi)
      @foos = Foo.scoped
    end

    it "returns the sortable objects if sort_param is nil" do
      expect(@api.sort_from_params(@foos, nil)).to eq(@foos)
    end

    it "sorts by a given parameter" do
      sorted = @api.sort_from_params(@foos, "param1")
      expect(sorted.last).to eq(@object3)
      expect(sorted.to_sql).to end_with("ORDER BY param1")
    end

    it "sorts by a given parameter descending if preceded by -" do
      sorted = @api.sort_from_params(@foos, "-param1")
      expect(sorted.first).to eq(@object3)
      expect(sorted.to_sql).to end_with("ORDER BY param1 DESC")
    end

    it "sorts by multiple parameters in order" do
      sorted = @api.sort_from_params(@foos, "param2,param1")
      expect(sorted.to_a).to eq([@object5, @object1, @object4, @object2, @object3])
      expect(sorted.to_sql).to end_with("ORDER BY param2, param1")

      alt_sorted = @api.sort_from_params(@foos, "param1,param2")
      expect(alt_sorted.to_a).to eq([@object5, @object4, @object1, @object2, @object3])
      expect(alt_sorted.to_sql).to end_with("ORDER BY param1, param2")
    end

    it "sorts by multiple parameters, even if descending" do
      sorted = @api.sort_from_params(@foos, "-param2,param1")
      expect(sorted.to_a).to eq([@object3, @object4, @object2, @object5, @object1])
      expect(sorted.to_sql).to end_with("ORDER BY param2 DESC, param1")
    end
  end
end
