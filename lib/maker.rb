module Maker
  def shortcuts_for(model)
    define_method(:new) do |*opts|
      Factory.build(model, opts.first || {})
    end

    define_method(:create) do |*opts|
      instance = Factory.build(model, opts.first || {})
      instance.save
      instance
    end

    define_method(:empty) do |*cols|
      opts = {}
      cols.each { |c| opts[c] = nil }
      instance = new(opts)
      instance.save
      instance
    end

  end

  def requires_presence_of(*cols)
    context "validation" do
      it "should have a valid factory" do
        new.should be_valid
      end

      cols.each do |col|
        it "should require #{col}" do
          empty(col).should have_at_least(1).error_on(col)
        end
      end
    end
  end

end