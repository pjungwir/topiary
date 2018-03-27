# Represents one vertex or node in your graph.
#
# Each node may hold some user-defined data,
# so you can track what they represent.
#
# Nodes also contain a list of "needs" (incoming edges)
# and "feeds" (outgoing edges).
# You may pass a list of connected nodes when you instantiate one,
# but usually you'll need to make your objects first
# and then add their needs/feeds.
# (If you didn't have to do that you probably wouldn't need this library, right?)
#
# There are mutator methods you can use like this:
#
#     n1 = Node.new "n1"
#     n2 = Node.new "n2"
#     n1.need! n2
#
# That will create an edge pointing from `n2` to `n1`.
#
# Once your graph is ready, you can pass the list of nodes to `Topiary.sort`.
class Topiary::Node
  attr_reader :data, :needs, :feeds

  def initialize(data=nil, needs=[], feeds=[])
    @data = data
    @needs = Set.new
    @feeds = Set.new
    needs.each{|n| need!(n)}
    feeds.each{|n| feed!(n)}
  end

  def begin!
    @original_needs = @needs
    @original_feeds = @feeds
    @needs = @needs.clone
    @feeds = @feeds.clone
  end

  # Since the sorting algorithm mutates the edges,
  # you can call this to restore everything to its original state.
  # The graph still isn't re-entrant,
  # but at least it comes back from sorting the same as it entered.
  def restore!
    @needs = @original_needs
    @feeds = @original_feeds
  end

  def need!(n)
    needs << n
    n.feeds << self
  end

  def feed!(n)
    feeds << n
    n.needs << self
  end

  def name
    data && data.to_s || object_id.to_s
  end

  def to_s
    [
      name,
      "needs:[" + needs.map(&:name).join(",") + "]",
      "feeds:[" + feeds.map(&:name).join(",") + "]",
    ].join(" ")
  end

  def inspect
    to_s
  end

  def clone
    Topiary::Node.new(data, needs, feeds)
  end

end
