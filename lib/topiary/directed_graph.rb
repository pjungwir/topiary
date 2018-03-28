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

    # Returns only those graphs that are topologically distinct
    def self.topologically_distinct(graphs)
      already_seen = Set.new
      Enumerator.new do |y|
        graphs.each do |g|
          is_new = true
          already_seen.each do |g2|
            if g2.topologically_equivalent? g
              is_new = false
              break
            end
          end
          if is_new
            y.yield g
            already_seen << g
          end
        end
      end
    end

    def initialize(nodes=[])
      super
      @forbid_cycles = false
    end

    def add_edge!(from_node, to_node)
      from_node.feed! to_node
      maybe_forbid_cycles!
    end

    def edges
      Enumerator.new do |y|
        nodes.each do |n|
          n.feeds.each do |n2|
            y.yield Edge.new(n, n2)
          end
        end
      end
    end

    # Two graphs A and B are topologically equivalent
    # if there is a bijection phi on the vertices
    # such that edge phi(u)phi(v) is in B iff uv is in A.
    def topologically_equivalent?(other)
      our_nodes = nodes.to_a
      other_nodes = other.nodes.to_a
      return false if our_nodes.size != other_nodes.size
      our_edges = edges.to_a
      other_edges = other.edges.to_a
      return false if our_edges.size != other_edges.size

      our_node_numbers = Hash[
        our_nodes.each_with_index.map{|n, i| [n, i]}
      ]

      # Since there are no permutations,
      # we have to special case graphs with 0 or 1 node:
      case our_nodes.size
      when 0
        true
      when 1
        true  # since we already know they have the same number of edges
      else
        # Now we have to try all permutations of the nodes:
        0.upto(nodes.size - 1).to_a.permutation.each do |phi|
          equivalent = true
          catch :answered do
            our_nodes.each_with_index do |u, i|
              phi_u = other_nodes[phi[i]]
              u.feeds.each do |v|
                phi_v = other_nodes[phi[our_node_numbers[v]]]
                if not phi_u.feeds.include?(phi_v)
                  equivalent = false
                  throw :answered
                end
              end
            end
          end
          return true if equivalent
        end
        false
      end
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
