# Ruby has no factorial function,
# but fact(n) == Math.gamma(n + 1)
def factorial(n)
  Math.gamma(n + 1)
end

module Topiary

  # A graph whose edges are directed instead of directionless
  class DirectedGraph < Graph

    def self.all_from_node_count(node_count)
      all_from_node_list(1.upto(node_count).map{|i| Node.new i.to_s})
    end

    # Assumes that all input nodes are edgeless.
    def self.all_from_node_list(nodes=[])
      Enumerator.new do |y|
        if nodes.empty?
          # There is one graph with zero nodes:
          y.yield DirectedGraph.new
        else
          # Find the number of combinations with replacement,
          # denoted
          #    n
          # ((   ))
          #    k
          #
          # which is
          #
          #   n + k - 1
          # (           )
          #      k
          #
          # and where
          #
          #   n          n!
          # (   ) = ------------
          #   k      k!(n - k)!
          node_count = nodes.size
          n = node_count + 2 - 1
          pair_count = factorial(n) /
                       (factorial(2) * factorial(n - 2))
          # Between every two nodes u & v there are 3 choices:
          #
          #   - no edge
          #   - edge from u to v
          #   - edge from v to u
          #
          # Except if u & v are the same node,
          # choice 2 & choice 3 are the same, so skip one of them.
          %w[. < >].repeated_permutation(pair_count).each do |edges|
            our_nodes = nodes.map(&:clone)
            pairs = our_nodes.repeated_combination(2).to_a
            g = DirectedGraph.new our_nodes
            skip = false
            edges.each_with_index do |dir, i|
              case dir
              when '.'
                # no edge
              when '<'
                pairs[i][0].need! pairs[i][1]
              when '>'
                # If the two nodes are the same,
                # we already did this:
                if pairs[i][0] == pairs[i][1]
                  skip = true
                  break
                end
                pairs[i][0].feed! pairs[i][1]
              end
            end
            y.yield g unless skip
          end
        end
      end
    end

    def self.acyclic_from_node_count(node_count)
      acyclic_from_node_list(1.upto(node_count).map{|i| Node.new i.to_s})
    end

    def self.acyclic_from_node_list(nodes=[])
      all_from_node_list(nodes).reject(&:has_cycles?).each(&:forbid_cycles!)
    end

    def initialize(nodes=[])
      super
      @forbid_cycles = false
    end

    def add_edge!(from_node, to_node)
      from_node.feed! to_node
      maybe_forbid_cycles!
    end

    # rubocop:disable Naming/PredicateName
    def has_cycles?
      Topiary.sort nodes
      false
    rescue InvalidGraph
      true
    end
    # rubocop:enable Naming/PredicateName

    def forbid_cycles!(v=true)
      @forbid_cycles = v
      maybe_forbid_cycles! if v
    end

    private

    def maybe_forbid_cycles!
      raise InvalidGraph, "Cycles found!" if @forbid_cycles and has_cycles?
    end

  end

end
