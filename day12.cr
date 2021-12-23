INPUT = <<-INPUT
FK-gc
gc-start
gc-dw
sp-FN
dw-end
FK-start
dw-gn
AN-gn
yh-gn
yh-start
sp-AN
ik-dw
FK-dw
end-sp
yh-FK
gc-gn
AN-end
dw-AN
gn-sp
gn-FK
sp-FK
yh-gc
INPUT

class Cave
    property name
    property links

    def initialize(@name : String)
        @links = Set(Cave).new
    end

    def link_to(other : Cave)
        return if @links.includes?(other)
        @links.add(other)
        other.link_to(self)
    end

    def start?
        @name == "start"
    end

    def end?
        @name == "end"
    end

    def small?
        @name.match(/[a-z]/)
    end
end

class Network
    property caves
    def initialize(lines)
        @caves = {} of String => Cave
        lines.each_line do |line|
            nodes = line.split("-")
            nodes.each do |n|
                if !caves.has_key?(n)
                    caves[n] = Cave.new(n)
                end
            end
            caves[nodes[0]].link_to(caves[nodes[1]])
        end
    end

    def all_paths
        dfs(caves["start"])
    end

    def dfs(current : Cave, visited = Set(Cave).new)
        if current.end?
            return [current.name]
        end
        visited.add(current)
        candidates = current.links.reject { |c| c.small? && visited.includes?(c) }
        paths = candidates.flat_map { |c| dfs(c, visited) }.map { |path| current.name + "->" + path }
        visited.delete(current)
        return paths
    end
end

netw = Network.new(INPUT)
allp = netw.all_paths
pp! allp.size
