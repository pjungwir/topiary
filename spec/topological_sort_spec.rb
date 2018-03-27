describe Topiary do

  it "sorts an empty graph" do
    expect(Topiary.sort([])).to eq []
  end

  it "raises on a one-node cycle" do
    n = Topiary::Node.new
    n.feed! n
    expect {
      Topiary.sort([n])
    }.to raise_error Topiary::InvalidGraph, "Leftover edges found: this graph has a cycle"
  end

  it "raises on a two-node cycle" do
    n1 = Topiary::Node.new
    n2 = Topiary::Node.new
    n1.feed! n2
    n2.feed! n1
    expect {
      Topiary.sort([n1, n2])
    }.to raise_error Topiary::InvalidGraph, "Leftover edges found: this graph has a cycle"
  end

  it "raises on a three-node cycle" do
    n1 = Topiary::Node.new
    n2 = Topiary::Node.new
    n3 = Topiary::Node.new
    n1.feed! n2
    n2.feed! n3
    n3.feed! n1
    expect {
      Topiary.sort([n1, n2, n3])
    }.to raise_error Topiary::InvalidGraph, "Leftover edges found: this graph has a cycle"
  end

  it "sorts a graph of one node" do
    n = Topiary::Node.new
    expect(Topiary.sort([n])).to eq [n]
  end

  it "sorts a graph of two connected nodes" do
    n1 = Topiary::Node.new "n1"
    n2 = Topiary::Node.new "n2"
    n1.feed! n2
    expect(Topiary.sort([n1, n2])).to eq [n1, n2]
    expect(Topiary.sort([n2, n1])).to eq [n1, n2]
  end

  it "sorts a graph of two disconnected nodes" do
    n1 = Topiary::Node.new "n1"
    n2 = Topiary::Node.new "n2"
    expect(Topiary.sort([n1, n2])).to eq [n1, n2]
    expect(Topiary.sort([n2, n1])).to eq [n2, n1]
  end

  context "with 3 nodes" do
    context "and 0 edges" do
      it "sorts 1 2 3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        expect(Topiary.sort([n1, n2, n3])).to eq [n1, n2, n3]
        expect(Topiary.sort([n1, n3, n2])).to eq [n1, n3, n2]
        expect(Topiary.sort([n2, n1, n3])).to eq [n2, n1, n3]
        expect(Topiary.sort([n2, n3, n1])).to eq [n2, n3, n1]
        expect(Topiary.sort([n3, n1, n2])).to eq [n3, n1, n2]
        expect(Topiary.sort([n3, n2, n1])).to eq [n3, n2, n1]
      end
    end
    context "and 1 edge" do
      it "sorts 1->2 3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n1.feed! n2
        expect(Topiary.sort([n1, n2, n3])).to eq [n1, n3, n2]
        expect(Topiary.sort([n1, n3, n2])).to eq [n1, n3, n2]
        expect(Topiary.sort([n2, n1, n3])).to eq [n1, n3, n2]
        expect(Topiary.sort([n2, n3, n1])).to eq [n3, n1, n2]
        expect(Topiary.sort([n3, n1, n2])).to eq [n3, n1, n2]
        expect(Topiary.sort([n3, n2, n1])).to eq [n3, n1, n2]
      end
    end
    context "and 2 edges" do
      it "sorts 1->2->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n1.feed! n2
        n2.feed! n3
        expect(Topiary.sort([n1, n2, n3])).to eq [n1, n2, n3]
        expect(Topiary.sort([n1, n3, n2])).to eq [n1, n2, n3]
        expect(Topiary.sort([n2, n1, n3])).to eq [n1, n2, n3]
        expect(Topiary.sort([n2, n3, n1])).to eq [n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2])).to eq [n1, n2, n3]
        expect(Topiary.sort([n3, n2, n1])).to eq [n1, n2, n3]
      end
      it "sorts 1->2<-3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n1.feed! n2
        n3.feed! n2
        expect(Topiary.sort([n1, n2, n3])).to eq [n1, n3, n2]
        expect(Topiary.sort([n1, n3, n2])).to eq [n1, n3, n2]
        expect(Topiary.sort([n2, n1, n3])).to eq [n1, n3, n2]
        expect(Topiary.sort([n2, n3, n1])).to eq [n3, n1, n2]
        expect(Topiary.sort([n3, n1, n2])).to eq [n3, n1, n2]
        expect(Topiary.sort([n3, n2, n1])).to eq [n3, n1, n2]
      end
      it "sorts 1<-2->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n2.feed! n1
        n2.feed! n3
        expect(Topiary.sort([n1, n2, n3])).to eq [n2, n1, n3]
        expect(Topiary.sort([n1, n3, n2])).to eq [n2, n1, n3]
        expect(Topiary.sort([n2, n1, n3])).to eq [n2, n1, n3]
        expect(Topiary.sort([n2, n3, n1])).to eq [n2, n1, n3]
        expect(Topiary.sort([n3, n1, n2])).to eq [n2, n1, n3]
        expect(Topiary.sort([n3, n2, n1])).to eq [n2, n1, n3]
      end
    end
    context "and 3 edges" do
      it "sorts 1<-2->3 and 1->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n2.feed! n1
        n2.feed! n3
        n1.feed! n3
        expect(Topiary.sort([n1, n2, n3])).to eq [n2, n1, n3]
        expect(Topiary.sort([n1, n3, n2])).to eq [n2, n1, n3]
        expect(Topiary.sort([n2, n1, n3])).to eq [n2, n1, n3]
        expect(Topiary.sort([n2, n3, n1])).to eq [n2, n1, n3]
        expect(Topiary.sort([n3, n1, n2])).to eq [n2, n1, n3]
        expect(Topiary.sort([n3, n2, n1])).to eq [n2, n1, n3]
      end
    end
  end

  context "with 4 nodes" do
    context "and 0 edges" do
      it "sorts 1 2 3 4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n3, n4, n1]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n4, n3, n1]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n2, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n2, n4, n1]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n4, n2, n1]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n2, n3, n1]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n3, n2, n1]
      end
    end

    context "and 1 edge" do
      it "sorts 1->2  3  4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n3, n1, n2]
      end
    end

    context "and 2 edges" do
      it "sorts 1->2  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n1, n4, n2]
      end
      it "sorts 1->2->3  4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n1, n2, n3]
      end
      it "sorts 1->2<-3  4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n3.feed! n2
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n3, n2]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n4, n1, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n3, n2]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n3, n1, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n3, n1, n2]
      end
      it "sorts 1<-2->3  4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n2.feed! n1
        n2.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n2, n4, n1, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n2, n1, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n2, n1, n3]
      end
    end

    context "and 3 edges" do
      # four-in-a-row:
      it "sorts 1->2->3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1->2->3<-4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n1, n2, n3]
      end
      it "sorts 1->2<-3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n3.feed! n2
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n1, n4, n2]
      end
      it "sorts 1<-2->3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n2.feed! n1
        n2.feed! n3
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n2, n1, n3, n4]
      end
      # triangle:
      it "sorts 1->2->3  1->3  4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n1.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n1, n2, n3]
      end
      # stars:
      it "sorts 1->2->3  4->2" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n1.feed! n2
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n1, n2, n3]
      end
      it "sorts 1->2->3  2->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n2.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1->2,3,4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n1.feed! n3
        n1.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1,2,3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n2.feed! n4
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n2, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n2, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n1, n2, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n1, n2, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n2, n1, n4]
      end
    end

    context "and 4 edges" do
      # into a triangle
      it "sorts 1->2  2->3,4  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n2.feed! n4
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1->2  2->3  4->2,3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n4.feed! n2
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n4, n1, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n4, n1, n2, n3]
      end
      it "sorts 1->2  3,4->2  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n3.feed! n2
        n3.feed! n4
        n4.feed! n2
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n3, n4, n2]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n1, n4, n2]
      end
      # out of a triangle
      it "sorts 1->2  3->1,2  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n3.feed! n1
        n3.feed! n2
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n1, n4, n2]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n1, n4, n2]
      end
      it "sorts 1->2,3  3->2  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n1.feed! n3
        n3.feed! n2
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n3, n2, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n3, n2, n4]
      end
      it "sorts 1->2,3  2->3  3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n1.feed! n3
        n2.feed! n3
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      # diamonds
      it "sorts 1->2->3->4  1->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n3
        n3.feed! n4
        n1.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1,2->3  1,2->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n3
        n2.feed! n3
        n1.feed! n4
        n2.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n2, n1, n3, n4]
      end
      it "sorts 1->2->4  1->3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n2.feed! n4
        n1.feed! n3
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
    end

    context "and 5 edges" do
      it "sorts 1->4  1->2,3  2,3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n1.feed! n2
        n1.feed! n3
        n2.feed! n4
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1->4  1->2,3  4->2,3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n1.feed! n2
        n1.feed! n3
        n4.feed! n2
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n4, n2, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n4, n2, n3]
      end
      it "sorts 1->4  1->2,3  2->4->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n1.feed! n2
        n1.feed! n3
        n2.feed! n4
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n4, n3]
      end
      it "sorts 1->4  2->1->3  2->4->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n2.feed! n1
        n1.feed! n3
        n2.feed! n4
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n2, n1, n4, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n2, n1, n4, n3]
      end
      it "sorts 1->4  2->1->3  2,3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n2.feed! n1
        n1.feed! n3
        n2.feed! n3
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n2, n1, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n2, n1, n3, n4]
      end
      it "sorts 1->4  2,3->1  2,3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n4
        n2.feed! n1
        n3.feed! n1
        n2.feed! n4
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n2, n3, n1, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n3, n2, n1, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n3, n2, n1, n4]
      end
    end

    context "and 6 edges" do
      it "sorts 1->2,3,4 and 2->3,4 and 3->4" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n1.feed! n3
        n1.feed! n4
        n2.feed! n3
        n2.feed! n4
        n3.feed! n4
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n3, n4]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n3, n4]
      end
      it "sorts 1->2,3,4 and 2->3,4 and 4->3" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        n3 = Topiary::Node.new "n3"
        n4 = Topiary::Node.new "n4"
        n1.feed! n2
        n1.feed! n3
        n1.feed! n4
        n2.feed! n3
        n2.feed! n4
        n4.feed! n3
        expect(Topiary.sort([n1, n2, n3, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n2, n4, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n3, n2, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n3, n4, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n4, n2, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n1, n4, n3, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n1, n3, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n1, n4, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n3, n1, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n3, n4, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n4, n1, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n2, n4, n3, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n1, n2, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n1, n4, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n2, n1, n4])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n2, n4, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n4, n1, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n3, n4, n2, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n1, n2, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n1, n3, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n2, n1, n3])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n2, n3, n1])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n3, n1, n2])).to eq [n1, n2, n4, n3]
        expect(Topiary.sort([n4, n3, n2, n1])).to eq [n1, n2, n4, n3]
      end
    end
  end

end
