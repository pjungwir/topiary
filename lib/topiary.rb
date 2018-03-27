require 'topiary/version'
require 'topiary/exceptions'
require 'topiary/node'
require 'topiary/graph'
require 'topiary/directed_graph'
require 'set'

# {Topiary} provides a topological sort function for Directed Acyclic Graphs.
module Topiary

  # Sorts node_list according to Kahn's Algorithm
  # ([from Wikipedia](https://en.wikipedia.org/wiki/Topological_sorting))
  # which runs in linear time:
  #
  #     L ← Empty list that will contain the sorted elements
  #     S ← Set of all nodes with no incoming edge
  #     while S is non-empty do
  #         remove a node n from S
  #         add n to tail of L
  #         for each node m with an edge e from n to m do
  #             remove edge e from the graph
  #             if m has no other incoming edges then
  #                 insert m into S
  #     if graph has edges then
  #         return error (graph has at least one cycle)
  #     else
  #         return L (a topologically sorted order)
  def self.sort(node_list)
    l = []
    s = Set.new(node_list.select{|n| n.needs.empty?})

    node_list.each(&:begin!)

    while not s.empty?
      n = s.first
      s.delete n
      l << n
      n.feeds.to_a.each do |m|
        n.feeds.delete m
        m.needs.delete n
        if m.needs.empty?
          s << m
        end
      end
    end

    # Make sure there were no cycles
    node_list.each do |n2|
      if n2.needs.any? or n2.feeds.any?
        raise InvalidGraph, "Leftover edges found: this graph has a cycle"
      end
    end

    l
  ensure
    node_list.each(&:restore!)
  end

end
