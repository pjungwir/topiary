module Topiary
  # Represents a Graph
  class Graph
    attr_reader :nodes

    def initialize(nodes=[])
      @nodes = nodes
    end

    def to_s
      ar = nodes.map(&:to_s)
      if ar.empty?
        "{ }"
      else
        "{ #{ar.join('; ')} }"
      end
    end

  end

end
