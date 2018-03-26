describe Topiary::Node do

  it "instantiates with no arguments" do
    n = Topiary::Node.new
    expect(n.data).to be_nil
    expect(n.needs).to eq Set.new
    expect(n.feeds).to eq Set.new
  end

  it "instantiates with a data argument" do
    n = Topiary::Node.new "n1"
    expect(n.data).to eq "n1"
    expect(n.needs).to eq Set.new
    expect(n.feeds).to eq Set.new
  end

  it "instantiates with needs" do
    n1 = Topiary::Node.new "n1"
    n2 = Topiary::Node.new "n2", [n1]
    expect(n2.data).to eq "n2"
    expect(n2.needs).to eq Set.new([n1])
    expect(n2.feeds).to eq Set.new

    expect(n1.data).to eq "n1"
    expect(n1.needs).to eq Set.new
    expect(n1.feeds).to eq Set.new([n2])
  end

  it "instantiates with feeds" do
    n1 = Topiary::Node.new "n1"
    n2 = Topiary::Node.new "n2", [], [n1]
    expect(n2.data).to eq "n2"
    expect(n2.needs).to eq Set.new
    expect(n2.feeds).to eq Set.new([n1])

    expect(n1.data).to eq "n1"
    expect(n1.needs).to eq Set.new([n2])
    expect(n1.feeds).to eq Set.new
  end

  it "gets its name from its data" do
    n = Topiary::Node.new "n1"
    expect(n.name).to eq "n1"
  end

  it "gets its name from its object id" do
    n = Topiary::Node.new
    expect(n.name).to eq n.object_id.to_s
  end

  it "shows its contents for debugging" do
    n1 = Topiary::Node.new "n1"
    n2 = Topiary::Node.new "n2"
    n3 = Topiary::Node.new "n3"
    n1.feed! n2
    n3.need! n2
    expect(n2.inspect).to eq "n2 needs:[n1] feeds:[n3]"
  end

end
