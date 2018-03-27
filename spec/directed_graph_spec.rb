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
      expect(Topiary::DirectedGraph.all_from_node_count(0).map(&:to_s).to_a).to eq [
        "{ }",
      ]
    end

    it "builds 1-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(1).map(&:to_s).to_a).to eq [
        "{ 1 needs:[] feeds:[] }",
        "{ 1 needs:[1] feeds:[1] }",
      ]
    end

    it "builds 2-node graphs" do
      expect(Topiary::DirectedGraph.all_from_node_count(2).map(&:to_s).to_a).to eq [
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
      expect(Topiary::DirectedGraph.all_from_node_count(3).map(&:to_s).to_a).to eq [
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
      expect(Topiary::DirectedGraph.acyclic_from_node_count(0).map(&:to_s).to_a).to eq [
        "{ }",
      ]
    end

    it "builds 1-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(1).map(&:to_s).to_a).to eq [
        "{ 1 needs:[] feeds:[] }",
      ]
    end

    it "builds 2-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(2).map(&:to_s).to_a).to eq [
        "{ 1 needs:[] feeds:[]; 2 needs:[] feeds:[] }",
        "{ 1 needs:[2] feeds:[]; 2 needs:[] feeds:[1] }",
        "{ 1 needs:[] feeds:[2]; 2 needs:[1] feeds:[] }",
      ]
    end

    it "builds 3-node graphs" do
      expect(Topiary::DirectedGraph.acyclic_from_node_count(3).map(&:to_s).to_a).to eq [
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

end
