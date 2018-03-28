describe Topiary::DirectedGraph do

  context "when allowing cycles" do
    context "#add_edge!" do
      it "adds an edge" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        graph = Topiary::DirectedGraph.new([n1, n2])
        graph.add_edge!(n1, n2)
        expect(graph.to_s).to eq "{ n1 needs:[] feeds:[n2]; n2 needs:[n1] feeds:[] }"
      end
      it "allows cycles" do
        n1 = Topiary::Node.new "n1"
        graph = Topiary::DirectedGraph.new([n1])
        graph.add_edge!(n1, n1)
        expect(graph.to_s).to eq "{ n1 needs:[n1] feeds:[n1] }"
      end
    end
  end

  context "when forbidding cycles" do
    context "#add_edge!" do
      it "adds an edge" do
        n1 = Topiary::Node.new "n1"
        n2 = Topiary::Node.new "n2"
        graph = Topiary::DirectedGraph.new([n1, n2])
        graph.forbid_cycles!
        graph.add_edge!(n1, n2)
        expect(graph.to_s).to eq "{ n1 needs:[] feeds:[n2]; n2 needs:[n1] feeds:[] }"
      end

      it "forbids cycles" do
        n1 = Topiary::Node.new "n1"
        graph = Topiary::DirectedGraph.new([n1])
        graph.forbid_cycles!
        expect {
          graph.add_edge!(n1, n1)
        }.to raise_error Topiary::InvalidGraph, "Cycles found!"
      end
    end
  end

  context ".all_from_node_count" do

    it "builds 0-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(0).map(&:to_s)).to eq [
        "{ }",
      ]
    end

    it "builds 1-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(1).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1] }",
      ]
    end

    it "builds 2-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(2).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2] feeds:[1,2] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2] feeds:[2] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[] feeds:[1] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2] feeds:[1,2] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2] feeds:[2] }",
      ]
    end

    it "builds 3-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(3).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2,3] feeds:[2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2,3] feeds:[2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2,3] feeds:[2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2,3] feeds:[2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2] feeds:[2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2] feeds:[2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[3] feeds:[]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2] feeds:[2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2] feeds:[2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2,3] feeds:[2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2,3] feeds:[2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2] feeds:[2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[2] feeds:[2,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2] feeds:[1,2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2] feeds:[1,2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2] feeds:[1,2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2] feeds:[1,2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[3] feeds:[1]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[3] feeds:[1]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2] feeds:[1,2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2] feeds:[1,2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2] feeds:[2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2] feeds:[2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1] feeds:[3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2] feeds:[2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2] feeds:[2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,3] feeds:[]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2] feeds:[2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2] feeds:[2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[] feeds:[]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[3] feeds:[]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[] feeds:[3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2] feeds:[2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2] feeds:[2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2,3] feeds:[2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2,3] feeds:[2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2] feeds:[2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1]; 2 needs:[2] feeds:[2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[] feeds:[]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[3] feeds:[]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[] feeds:[3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2] feeds:[2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2] feeds:[2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2,3] feeds:[2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2,3] feeds:[2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2] feeds:[2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1]; 2 needs:[2] feeds:[2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[] feeds:[]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[3] feeds:[]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[] feeds:[3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[] feeds:[3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2] feeds:[2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2] feeds:[2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2,3] feeds:[2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2,3] feeds:[2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2] feeds:[2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,3]; 2 needs:[2] feeds:[2,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[] feeds:[1]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[3] feeds:[1]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[] feeds:[1,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2] feeds:[1,2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2] feeds:[1,2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[] feeds:[1]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[3] feeds:[1]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[] feeds:[1,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2] feeds:[1,2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2] feeds:[1,2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,2,3] feeds:[1]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[] feeds:[1]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[] feeds:[1]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[3] feeds:[1]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[3] feeds:[1]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[] feeds:[1,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[] feeds:[1,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2] feeds:[1,2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2] feeds:[1,2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2,3] feeds:[1,2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1,2] feeds:[1,3]; 2 needs:[2] feeds:[1,2,3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1] feeds:[]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,3] feeds:[]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1] feeds:[3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2] feeds:[2]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2] feeds:[2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1] feeds:[]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,3] feeds:[]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1] feeds:[3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2] feeds:[2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2] feeds:[2]; 3 needs:[3] feeds:[1,3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[3] feeds:[1,2,3] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[1,3] feeds:[1,2]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[2,3] feeds:[1,3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1] feeds:[]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,3] feeds:[]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1] feeds:[3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1] feeds:[3]; 3 needs:[1,2,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2] feeds:[2]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2] feeds:[2]; 3 needs:[1,3] feeds:[3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2,3] feeds:[2]; 3 needs:[1,3] feeds:[2,3] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[1] feeds:[1,2,3]; 2 needs:[1,2] feeds:[2,3]; 3 needs:[1,2,3] feeds:[3] }",
      ]
    end

  end

  context ".acyclic_from_node_count" do

    it "builds 0-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(0).map(&:to_s)).to eq [
        "{ }",
      ]
    end

    it "builds 1-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(1).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[] }",
      ]
    end

    it "builds 2-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(2).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[] }",
      ]
    end

    it "builds 3-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(3).map(&:to_s)).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[3] feeds:[1]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[2,3] feeds:[]; 2 needs:[] feeds:[1,3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[2] feeds:[3]; 2 needs:[] feeds:[1,3]; 3 needs:[1,2] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[2] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[3]; 3 needs:[2] feeds:[] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1] feeds:[]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[3] feeds:[2]; 2 needs:[1,3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[]; 3 needs:[1] feeds:[] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1,3] feeds:[]; 3 needs:[1] feeds:[2] }",
        "{ 1 needs:[] feeds:[2,3]; 2 needs:[1] feeds:[3]; 3 needs:[1,2] feeds:[] }",
      ]
    end

  end

  context "#edges" do
    it "gives edges for a 0-node graph" do
      expect(Topiary::DirectedGraph.new.edges.to_a).to eq []
    end

    it "gives edges for a 1-node graph" do
      n1 = Topiary::Node.new "n1"
      g = Topiary::DirectedGraph.new [n1]
      expect(g.edges.map(&:to_s)).to eq []
      g.add_edge! n1, n1
      expect(g.edges.map(&:to_s)).to eq ["n1->n1"]
    end

    it "gives edges for a 2-node graph" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g = Topiary::DirectedGraph.new [n1, n2]
      expect(g.edges.map(&:to_s)).to eq []
      g.add_edge! n1, n1
      g.add_edge! n1, n2
      expect(g.edges.map(&:to_s)).to eq ["n1->n1", "n1->n2"]
      g.add_edge! n2, n1
      expect(g.edges.map(&:to_s)).to eq ["n1->n1", "n1->n2", "n2->n1"]
    end
  end

  context "#topologically_equivalent?" do
    it "is false for graphs with different node counts" do
      g1 = Topiary::DirectedGraph.new
      n1 = Topiary::Node.new "n1"
      g2 = Topiary::DirectedGraph.new [n1]
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)
    end

    it "is false for graphs with different edge counts" do
      n1 = Topiary::Node.new "n1"
      g1 = Topiary::DirectedGraph.new [n1]
      g1.add_edge! n1, n1
      n2 = Topiary::Node.new "n2"
      g2 = Topiary::DirectedGraph.new [n2]
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)
    end

    it "is true for graphs with 0 nodes" do
      g1 = Topiary::DirectedGraph.new
      g2 = Topiary::DirectedGraph.new
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is true for graphs with 1 node and 0 edges" do
      n1 = Topiary::Node.new "n1"
      g1 = Topiary::DirectedGraph.new [n1]
      n2 = Topiary::Node.new "n2"
      g2 = Topiary::DirectedGraph.new [n2]
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is true for graphs with 1 node and 1 edge" do
      n1 = Topiary::Node.new "n1"
      g1 = Topiary::DirectedGraph.new [n1]
      g1.add_edge! n1, n1
      n2 = Topiary::Node.new "n2"
      g2 = Topiary::DirectedGraph.new [n2]
      g2.add_edge! n2, n2
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is true for graphs with 2 nodes and 0 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is true for some graphs with 2 nodes and 1 edge" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n1
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n3
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n2
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is false for some graphs with 2 nodes and 1 edge" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n1
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n4
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)
    end

    it "is true for some graphs with 2 nodes and 2 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n1
      g1.add_edge! n2, n2
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n3
      g2.add_edge! n4, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n1
      g1.add_edge! n1, n2
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n3
      g2.add_edge! n3, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n2
      g1.add_edge! n2, n1
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n4
      g2.add_edge! n4, n3
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is false for some graphs with 2 nodes and 2 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      g1 = Topiary::DirectedGraph.new [n1, n2]
      g1.add_edge! n1, n1
      g1.add_edge! n1, n2
      n3 = Topiary::Node.new "n3"
      n4 = Topiary::Node.new "n4"
      g2 = Topiary::DirectedGraph.new [n3, n4]
      g2.add_edge! n3, n4
      g2.add_edge! n4, n3
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)
    end

    it "is true for graphs with 3 nodes and 0 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is true for some graphs with 3 nodes and 1 edge" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n5
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n3
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n6, n5
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is false for some graphs with 3 nodes and 1 edge" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n6, n5
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)
    end

    it "is true for some graphs with 3 nodes and 2 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n2, n2
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n4, n4
      g1.add_edge! n6, n6
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n1, n3
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n6, n6
      g1.add_edge! n6, n5
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n3, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n4, n4
      g1.add_edge! n5, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n2, n3
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n6, n6
      g1.add_edge! n4, n5
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n2
      g1.add_edge! n1, n3
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n6
      g1.add_edge! n5, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n2, n1
      g1.add_edge! n3, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n4
      g1.add_edge! n6, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n2
      g1.add_edge! n2, n3
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n6
      g1.add_edge! n6, n4
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)
    end

    it "is false for some graphs with 3 nodes and 2 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n2, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n4
      g1.add_edge! n6, n4
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)

      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n1
      g1.add_edge! n1, n2
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n4
      g1.add_edge! n6, n4
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)

      # not exhaustive...
    end

    it "is true for some graphs with 3 nodes and 3 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n2
      g1.add_edge! n2, n3
      g1.add_edge! n3, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n5, n6
      g1.add_edge! n6, n4
      g1.add_edge! n4, n5
      expect(g1).to be_topologically_equivalent(g1)
      expect(g1).to be_topologically_equivalent(g2)
      expect(g2).to be_topologically_equivalent(g1)

      # not exhaustive...
    end

    it "is false for some graphs with 3 nodes and 3 edges" do
      n1 = Topiary::Node.new "n1"
      n2 = Topiary::Node.new "n2"
      n3 = Topiary::Node.new "n3"
      g1 = Topiary::DirectedGraph.new [n1, n2, n3]
      g1.add_edge! n1, n2
      g1.add_edge! n2, n3
      g1.add_edge! n3, n1
      n4 = Topiary::Node.new "n4"
      n5 = Topiary::Node.new "n5"
      n6 = Topiary::Node.new "n6"
      g2 = Topiary::DirectedGraph.new [n4, n5, n6]
      g1.add_edge! n4, n5
      g1.add_edge! n5, n6
      g1.add_edge! n4, n6
      expect(g1).not_to be_topologically_equivalent(g2)
      expect(g2).not_to be_topologically_equivalent(g1)

      # not exhaustive...
    end
  end

  context ".topologically_distinct" do
    it "find all graphs with 3 nodes and 2 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.all_from_node_count(3).select{|g| g.edges.count == 2}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[3] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2,3] feeds:[3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[3] feeds:[3] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[] feeds:[3]; 3 needs:[2] feeds:[1] }",
        "{ 1 needs:[3] feeds:[]; 2 needs:[2] feeds:[2]; 3 needs:[] feeds:[1] }",
        "{ 1 needs:[] feeds:[3]; 2 needs:[] feeds:[3]; 3 needs:[1,2] feeds:[] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 0 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 0}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[] feeds:[]; 4 needs:[] feeds:[] }",
      ]
    end
    it "find acyclic graphs with 4 nodes and 1 edge" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 1}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[]; 3 needs:[4] feeds:[]; 4 needs:[] feeds:[3] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 2 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 2}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[4] feeds:[]; 3 needs:[4] feeds:[]; 4 needs:[] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[4] feeds:[]; 3 needs:[] feeds:[4]; 4 needs:[3] feeds:[2] }",
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[4]; 3 needs:[] feeds:[4]; 4 needs:[2,3] feeds:[] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[] feeds:[2]; 4 needs:[] feeds:[1] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 3 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 3}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[4] feeds:[2]; 4 needs:[] feeds:[2,3] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[4] feeds:[]; 3 needs:[4] feeds:[]; 4 needs:[] feeds:[1,2,3] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[4] feeds:[]; 3 needs:[] feeds:[4]; 4 needs:[3] feeds:[1,2] }",

        "{ 1 needs:[4] feeds:[]; 2 needs:[] feeds:[4]; 3 needs:[] feeds:[4]; 4 needs:[2,3] feeds:[1] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[3] feeds:[]; 3 needs:[4] feeds:[2]; 4 needs:[] feeds:[1,3] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[] feeds:[2]; 4 needs:[] feeds:[1,2] }",

        "{ 1 needs:[4] feeds:[]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[2]; 4 needs:[2] feeds:[1] }",
        "{ 1 needs:[] feeds:[4]; 2 needs:[] feeds:[4]; 3 needs:[] feeds:[4]; 4 needs:[1,2,3] feeds:[] }",
        "{ 1 needs:[] feeds:[4]; 2 needs:[3,4] feeds:[]; 3 needs:[] feeds:[2]; 4 needs:[1] feeds:[2] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 4 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 4}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[4] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[4] feeds:[2]; 4 needs:[] feeds:[1,2,3] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[] feeds:[2,4]; 4 needs:[3] feeds:[1,2] }",
        "{ 1 needs:[4] feeds:[]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[2,4]; 4 needs:[2,3] feeds:[1] }",

        "{ 1 needs:[] feeds:[4]; 2 needs:[3,4] feeds:[]; 3 needs:[4] feeds:[2]; 4 needs:[1] feeds:[2,3] }",
        "{ 1 needs:[] feeds:[4]; 2 needs:[3,4] feeds:[]; 3 needs:[] feeds:[2,4]; 4 needs:[1,3] feeds:[2] }",
        "{ 1 needs:[] feeds:[4]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[2,4]; 4 needs:[1,2,3] feeds:[] }",

        "{ 1 needs:[3,4] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[] feeds:[1,2]; 4 needs:[] feeds:[1,2] }",
        "{ 1 needs:[3,4] feeds:[]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[1,2]; 4 needs:[2] feeds:[1] }",
        "{ 1 needs:[3,4] feeds:[]; 2 needs:[] feeds:[3,4]; 3 needs:[2] feeds:[1]; 4 needs:[2] feeds:[1] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 5 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 5}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[3,4] feeds:[]; 2 needs:[3,4] feeds:[]; 3 needs:[4] feeds:[1,2]; 4 needs:[] feeds:[1,2,3] }",
        "{ 1 needs:[3,4] feeds:[]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[1,2,4]; 4 needs:[2,3] feeds:[1] }",
        "{ 1 needs:[3,4] feeds:[]; 2 needs:[] feeds:[3,4]; 3 needs:[2,4] feeds:[1]; 4 needs:[2] feeds:[1,3] }",

        "{ 1 needs:[3] feeds:[4]; 2 needs:[3] feeds:[4]; 3 needs:[] feeds:[1,2,4]; 4 needs:[1,2,3] feeds:[] }",
        "{ 1 needs:[3] feeds:[4]; 2 needs:[] feeds:[3,4]; 3 needs:[2] feeds:[1,4]; 4 needs:[1,2,3] feeds:[] }",
        "{ 1 needs:[] feeds:[3,4]; 2 needs:[] feeds:[3,4]; 3 needs:[1,2,4] feeds:[]; 4 needs:[1,2] feeds:[3] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 6 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 6}
      ).map(&:to_s)
      expect(graphs).to eq [
        "{ 1 needs:[2,3,4] feeds:[]; 2 needs:[3,4] feeds:[1]; 3 needs:[4] feeds:[1,2]; 4 needs:[] feeds:[1,2,3] }",
      ]
    end

    it "find acyclic graphs with 4 nodes and 7 edges" do
      graphs = Topiary::DirectedGraph.topologically_distinct(
        Topiary::DirectedGraph.acyclic_from_node_count(4).select{|g| g.edges.count == 7}
      ).map(&:to_s)
      expect(graphs).to eq []
    end
  end

end
