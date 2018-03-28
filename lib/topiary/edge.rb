module Topiary
  # Represents an edge between two nodes in a graph.
  class Edge
    attr_reader :feeder, :needer

    def initialize(feeder, needer)
      @feeder = feeder
      @needer = needer
    end

    def to_s
      [
        feeder.name,
        needer.name,
      ].join("->")
    end
  end
end
