-- //
local UnionManager = {}
UnionManager.__index = UnionManager
UnionManager.__type = "UnionManager"
do
    -- // Constructor
    function UnionManager.new(Count)
        -- // Failsafe
        assert(Count > 0, "Count cannot be negative")

        -- // Create the object
        local self = setmetatable({}, UnionManager)

        -- // Vars
        self.Count = 0
        self.Parents = {}
        self.Sizes = {}

        -- // Create the sets
        for i = 1, #Count do
            self:AddSet()
        end

        -- // Return object
        return self
    end

    -- //
    function UnionManager.AddSet(self)
        -- // Vars
        local Index = #self.Parents

        -- // Update our tables
        table.insert(self.Parents, Index)
        table.insert(self.Sizes, 1)

        -- // Increment count by one
        self.Count = self.Count + 1
    end

    -- //
    function UnionManager.GetRoot(self, i)
        -- // Ensure i is in valid range
        assert(0 <= i < #self.Parents, "i out of range")

        -- // Vars
        local Parent = self.Parents[i]

        -- // Constantly repeat until we have the root
        while (true) do wait()
            -- // Grab the parent of the parent
            local GrandParent = self.Parents[Parent]

            -- // Check if we found the root
            if (GrandParent == Parent) then
                return Parent
            end

            -- // Partial Path Compression
            self.Parents[i] = GrandParent

            -- // For the next iteration
            i = Parent
            Parent = GrandParent
        end
    end

    -- //
    function UnionManager.Merge(self, i, i2)
        -- // Grab our root node
        local RootA = self:GetRoot(i)
        local RootB = self:GetRoot(i2)

        -- // Make sure they are not the same ones
        if (RootA == RootB) then
            return false
        end

        -- // Swap the roots if A is smaller
        if (self.Sizes[RootA] < self.Sizes[RootB]) then
            RootA, RootB = RootB, RootA
        end

        -- // Graft B's subtree -> A
        self.Parents[RootB] = RootA
        self.Sizes[RootA] = self.Sizes[RootA] + self.Sizes[RootB]
        self.Sizes[RootB] = 0
        self.Count = self.Count - 1

        -- // Done
        return true
    end
end

-- //
local MSTManager = {}
MSTManager.__index = MSTManager
MSTManager.__type = "MSTManager"
do
    -- // Vars

    -- // Constructor
    function MSTManager.new(Nodes)
        -- // Create the object
        local self = setmetatable({}, MSTManager)

        -- // Vars
        self.Nodes = Nodes

        -- // Return the object
        return self
    end

    -- // Calculates the distance between two nodes (static)
    function MSTManager.CalculateDistance(A, B)
        return (A - B).Magnitude
    end

    -- // Calculate score between each note (upon Distance)
    function MSTManager.CalculateScores(self)
        -- // Vars
        local Graph = {}
        local NodeLength = #self.Nodes

        -- // Loop through nodes 1 -> length. For a visualisation of how this works, view the readme
        for i = 1, NodeLength - 1 do
            -- // Vars
            local Node = self.Nodes[i]

            -- // Loop through each sub node
            for j = i + 1, NodeLength do
                -- // Calculate the score / distance
                local SubNode = self.Nodes[j]
                local Distance = self.CalculateDistance(Node, SubNode)

                -- // Add to tree
                table.insert(Graph, {
                    Nodes = {i, j},
                    Score = Distance
                })
            end
        end

        -- // Sort the graph based upon Score
        table.sort(Graph, function(A, B)
            return A.Score < B.Score
        end)

        -- // Returns the tree and lowest data
        return Graph
    end

    -- // Runs the Kruskal Algorithm
    function MSTManager.RunKruskal(self)
        -- // Vars
        local Graph = self:CalculateScores()
        local Union = UnionManager.new(#Graph)
        local Result = {}

        local SortedEdges = 0
        local i = 0

        -- // The main logic
        while (i < Union.Count - 1) do
            -- // Grab the data
            local Node = Graph[i]
            local u, v = unpack(Node.Nodes)

            -- // Increment iterator
            i = i + 1

            -- // Grab roots
            local RootA = Union:GetRoot(u)
            local RootB = Union:GetRoot(v)

            -- // Make sure are not the same
            if (RootA == RootB) then
                continue
            end

            -- // Increment counter
            SortedEdges = SortedEdges + 1

            -- // Add to result and merge
            table.insert(Result, Node)
            Union:Merge(u, v)
        end

        -- // Return
        return Result
    end

end

-- // Return
return MSTManager