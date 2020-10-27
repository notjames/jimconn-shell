#!/usr/bin/env ruby
## Jim Conner

INPUT = [ ['Logging', 'Memory'], ['Apex', 'Database'],
          ['Database', 'Logging'], ['Apex', 'Logging'],
          ['Logging', 'IO'] ]
deps = {}

# Walk element 1 of inner arrays and seek deps
# through each dep
# make it recursive.
def find_deps(seek_for, from, found = {})
  from.each \
  {|ele|
    found[seek_for] = [] if found[seek_for].nil?

    if seek_for == ele[0]
      # ignore dupes
      found[seek_for] << ele[1] unless found[seek_for].include? ele[1]
    end

    find_deps ele[1], from.drop(1), found
  }

  found
end

def what_requires(deps, seek, dep_graph = [])
  dep_graph << seek

  deps.each \
  {|dep, v|
    if v.include? seek
      # this one needs to go first
      if deps[dep].count > 1
        deps[dep].each\
        {|d|
          next if dep_graph.include? d
          what_requires deps, d, dep_graph
        }
      else
        dep_graph << dep

        next if dep_graph.include? dep
        what_requires deps, dep, dep_graph
      end
    end
  }

  dep_graph
end

# graph deps
def graph(deps)
  ground_lvl = nil
  top        = nil
  bottoms    = []
  graph      = []

  # find the "bottom" of the graph
  # first. This will be found by
  # having an empty list in the
  # data structure.
  deps.each \
  {|dep, v|
    # bottom
    if v.empty?
      deps.each{|k,v2| ground_lvl = k if v2.include? dep}
      bottoms.push dep unless ground_lvl.nil?
      # don't need th(is|ese) anymore
      deps.delete dep
    end
  }

  # Also find the "top" of the graph
  # next. This is the main application
  # This is the one which is a key in the
  # data structure and never a dependency
  top = (deps.keys) - (deps.values.flatten)

  # Set the base of the graph
  graph << bottoms

  # walk the graph
  graph << what_requires(deps, ground_lvl) << top

  graph
end

# Now let's output the graph given the newly
# created dep structure
def outp(deps)
  puts (graph deps).flatten.uniq.join(' -> ')
end

# The easy part...
#  associate the inner loop dependencies
#  IE Logging deps on Memory, Apex deps on DB, etc
INPUT.each\
{|ele|
  deps[ele[0]] = [] if deps[ele[0]].nil?
  deps[ele[0]] << ele[1]
}

outp find_deps INPUT[0][1], INPUT, deps
